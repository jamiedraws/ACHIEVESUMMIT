<%@ WebHandler Language="C#" Class="InviteGuest" %>

using Dtm.Framework.Base.Configuration;
using Dtm.Framework.ClientSites;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.ClientSites.Web.ModelValidation;
using Dtm.Framework.Models.Ecommerce;
using Dtm.Framework.Models.Ecommerce.Repositories;
using System;
using System.Web;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
using System.Xml;
using System.Xml.Linq;
using System.Xml.Xsl;



public class InviteGuest : IHttpHandler
{

    private HttpRequest Request { get; set; }

    public void ProcessRequest(HttpContext context)
    {
        Request = context.Request;
        var errors = new List<string>();
        Result result = new Result();
        try
        {
            Guid overrideCovId = Guid.TryParse(Request["COVID"], out overrideCovId) ? overrideCovId : Guid.Empty;
            if (overrideCovId == Guid.Empty && Request.UrlReferrer != null)
            {
                var offerVersionPage = Request.UrlReferrer.AbsolutePath;
                offerVersionPage = Regex.Match(offerVersionPage, "^[/](.*?[/].*)[/].*?$").Groups[1].Value;
                if (!string.IsNullOrWhiteSpace(offerVersionPage))
                {
                    var offerVersion = offerVersionPage.Split('/');
                    var offerCode = offerVersion[0];
                    var routeVersionText = offerVersion[1];
                    decimal version;
                    Decimal.TryParse(routeVersionText, out version);

                    overrideCovId = DtmContext.CampaignOfferVersions
                       .Where(cov => cov.OfferCode.Equals(offerCode, StringComparison.InvariantCultureIgnoreCase) && cov.VersionNumber == version)
                       .Select(cov => cov.OfferVersionId)
                       .FirstOrDefault();
                }
            }
            var defaultOfferVersion = DtmContext.CampaignOfferVersions
                 .FirstOrDefault(cov => (overrideCovId == Guid.Empty && cov.IsDefault) || cov.OfferVersionId == overrideCovId)
             ?? DtmContext.CampaignOfferVersions
                 .First(cov => cov.IsDefault);
            DtmContext.VersionId = defaultOfferVersion.OfferVersionId;
            DtmContext.OfferCode = defaultOfferVersion.OfferCode;
            DtmContext.Version = defaultOfferVersion.VersionNumber;

            var formCollection = Request.Params;
            var mode = formCollection["mode"]; // control, ajax,content,or view result
            var oid = formCollection["oid"];
            var fname = formCollection["FirstName"];
            var lname = formCollection["LastName"];
            var email = formCollection["Email"];
            var covId = formCollection["covId"];
            var vsId = formCollection["vsId"];
            var subject = SettingsManager.ContextSettings["InviteAGuest.Subject"];
            var fileName = formCollection["t"]; // email template name - default is EmailLead.xslt
            var fromDomain = formCollection["f"];
            var referenceLink = formCollection["r"]
                ?? (Request.UrlReferrer == null ? (Request.Url == null ? string.Empty : Request.Url.ToString()) : Request.UrlReferrer.ToString());

            var firstName = fname;
            var lastName = lname;
            Guid visitorSessionId = vsId == null
                ? DtmContext.VisitorSessionId
                : Guid.TryParse(vsId, out visitorSessionId) ? visitorSessionId : DtmContext.VisitorSessionId;
            Guid campaignOfferVersionId = Guid.TryParse(covId, out campaignOfferVersionId)
                ? campaignOfferVersionId
                : DtmContext.VersionId;
            int orderId;
            Order order;
            if (int.TryParse(oid, out orderId))
            {
                var orderRepository = new OrderRepository(EcommerceDataContextManager.Current);
                order = orderRepository.GetByOrderId(orderId);

                firstName = order.BillingFirstName;
                lastName = order.BillingLastName;
                visitorSessionId = order.VisitorSessionId;
            }
            else
            {
                order = new Order
                {
                    BillingFirstName = firstName,
                    BillingLastName = lastName,
                    Email = email,
                    CampaignOfferVersionID = campaignOfferVersionId,
                    VisitorSessionId = visitorSessionId,
                };
            }

            var fromFirstName = Regex.Replace(firstName.Replace(" ", "").Normalize(NormalizationForm.FormD), "[^A-Za-z| ]", string.Empty);
            var fromLastName = Regex.Replace(lastName.Replace(" ", "").Normalize(NormalizationForm.FormD), "[^A-Za-z| ]", string.Empty);
            var lead = new VersionLead
            {
                VersionLeadId = Guid.NewGuid(),
                FirstName = fname,
                LastName = lname,
                Email = email,
                CampaignOfferVersionID = campaignOfferVersionId,
                VisitorSessionId = visitorSessionId,
                ReferredTo = referenceLink,
                FromAddress =
                string.IsNullOrWhiteSpace(fromFirstName) && string.IsNullOrWhiteSpace(fromLastName)
                ? "event@" + fromDomain
                : string.Format("{0}.{1}@{2}", fromFirstName, fromLastName, fromDomain),
                AddDate = DateTime.Now,
                AddUser = FrameworkCommon.APPLICATION_NAME,
                ChangeDate = DateTime.Now,
                ChangeUser = FrameworkCommon.APPLICATION_NAME
            };

            var validator = new SiteLeadValidator();
            validator.IsValid = validator.Validate(lead).IsValid;
            if (validator.IsValid)
            {
                var leadsRepository = new AdditionalLeadsRepository(EcommerceDataContextManager.Current);
                leadsRepository.Add(lead);
                leadsRepository.Save();
                SendMail(lead, order, fileName, subject);
            }
            else
            {
                errors.Add(LabelsManager.Labels["SeminarInvalidData"]);
            }

            result = new Result
            {
                id = lead.VersionLeadId,
                oid = orderId,
                r = referenceLink,
                f = fromDomain
            };
        }
        catch (Exception ex)
        {
            errors.Add(ex.Message);
        }

        result.error = errors;

        context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
        context.Response.ContentType = "application/json";
        context.Response.Write(new JavaScriptSerializer().Serialize(result));
    }

    private class Result
    {
        public Guid id { get; set; }
        public int oid { get; set; }
        public string r { get; set; }
        public string f { get; set; }
        public List<string> error { get; set; }
    }

    private void SendMail(VersionLead lead, Order order, string fileName, string subject)
    {
        var emailSent = false;
        if (SettingsManager.ContextSettings["AdditionLead.SendEmail", true])
        {
            var xsl = new XslCompiledTransform();

            Guid emailTemplateId =
                Guid.TryParse(SettingsManager.ContextSettings["AdditionLead.EmailTemplateId"], out emailTemplateId)
                ? emailTemplateId : Guid.Empty;
            var isEmailTemplateLoaded = false;
            if (emailTemplateId != Guid.Empty)
            {
                var emailTemplate = EcommerceDataContextManager.Current.EmailTemplates
                 .Where(et => et.EmailTemplateId == emailTemplateId)
                 .Select(et => et.EmailBody)
                 .FirstOrDefault();
                if (emailTemplate != null)
                {
                    isEmailTemplateLoaded = true;
                    xsl.Load(new XmlTextReader(new StringReader(emailTemplate)));
                }
            }

            if (!isEmailTemplateLoaded)
            {
                fileName = (fileName ?? "EmailLead").Split('.')[0];
                var filepath = AppDomain.CurrentDomain.BaseDirectory
                    + fileName
                    + SettingsManager.ContextSettings["AdditionLead.EmailFileExtension", ".xslt"];
                xsl.Load(filepath);
            }

            var message = new MailMessage { From = new MailAddress(lead.FromAddress) };
            message.To.Add(new MailAddress(lead.Email));
            message.BodyEncoding = Encoding.UTF8;
            message.IsBodyHtml = true;
            message.Subject = subject ??
                              string.Format(LabelsManager.Labels["SeminarEmailInvite"], order.BillingFirstName,
                                  order.BillingLastName);
            message.Body = GetFormattedBody(CreateXml(lead, order), xsl);

            var client = new SmtpClient { Host = ConfigurationManager.AppSettings["SMTPServer"] };
            try
            {
                client.Send(message);
                emailSent = true;
            }
            catch (SmtpFailedRecipientException ex)
            {
                SiteExceptionHandler.HandleException(ex);
            }
        }
        else
        {
            emailSent = true;
        }
        if (emailSent)
        {
            lead.EmailSentDate = DateTime.Now;
            var leadsRepository = new AdditionalLeadsRepository(EcommerceDataContextManager.Current);
            leadsRepository.Save();
        }
    }

    private XDocument CreateXml(VersionLead lead, Order order)
    {
        var impressionPixelUrl = string.Empty;
        var trackingUrl = string.Empty;
        if (order.OrderID > 0)
        {
            var serviceInterfaceOrdersRepository = new ServiceInterfaceOrderRepository(EcommerceDataContextManager.Current);
            var serviceInterfaceOrderId = serviceInterfaceOrdersRepository.AddServiceOrder(order.OrderID, "EMAILLEADS");
            impressionPixelUrl = string.Format("https://thirdparty.digitaltargetmarketing.com/global/services/pixeltracker.ashx?at=impression&oid={0}&tpid={1}", serviceInterfaceOrderId, 14);
            trackingUrl = string.Format("<img style=\"display:none;\" src=\"{0}\" />", impressionPixelUrl);
        }

        var referredTo = lead.ReferredTo;
        var referUrl = string.Format("<a href='{0}'>Click Here </a>", referredTo);
        var domain = string.Empty;

        if (Request == null || Request.Url == null)
            SiteExceptionHandler.HandleException("AdditionalLeads::CreateXML:: Request.Url was null. " + order.OrderID);
        else
            domain = Request.Url.GetComponents(UriComponents.SchemeAndServer, UriFormat.Unescaped);
        var inviteImage =
            string.Format("<a href='{0}'><img alt='Click here to register now!' width='500' height='300' border='0' style='padding-top:10px;' src='{1}/images/invite-email.gif' /></a>",
                referredTo,
                domain);
        var inviteImageUrl = string.Format("{0}/images/invite-email.gif", domain);

        var doc = new XDocument(new XElement("Lead",
            new XElement("FirstName", order.BillingFirstName),
            new XElement("LastName", order.BillingLastName),
            new XElement("Email", order.Email),
            new XElement("LeadFirstName", lead.FirstName),
            new XElement("LeadLastName", lead.LastName),
            new XElement("LeadEmail", lead.Email),
            new XElement("COVID", order.CampaignOfferVersionID),
            new XElement("InviteImage", inviteImage),
            new XElement("InviteImageUrl", inviteImageUrl),
            new XElement("TrackingUrl", trackingUrl),
            new XElement("ReferUrl", referUrl),
            new XElement("ImpressionPixelUrl", impressionPixelUrl),
            new XElement("ReferredTo", referredTo),
            new XElement("Domain", domain),
            new XElement("CampaignName", DtmContext.Campaign.CampaignName),
            new XElement("CampaignCode", DtmContext.CampaignCode),
            new XElement("OfferCode", DtmContext.OfferCode),
            new XElement("Version", DtmContext.Version),
            new XElement("TimeStamp", DateTime.Now),
            new XElement("TimeStampG", DateTime.Now.ToString("G")),
            new XElement("AppV", DtmContext.ApplicationVersion)
        ));

        var seminarItem = order.OrderItems.Where(oi => oi.CachedProductInfo.ProductTypeId == 0).FirstOrDefault();
        if (seminarItem != null)
        {
            var seminarRepository = new SeminarRepository(EcommerceDataContextManager.Current);
            var campaignOfferVersionId =
                (order.CampaignOfferVersionID ?? order.VisitorSessions.CampaignOfferVersionID)
                ?? DtmContext.VersionId;
            var seminarTimeData = seminarRepository
                .GetSeminarTimeByProductCode(seminarItem.CampaignProduct.ProductCode, campaignOfferVersionId);

            var seminarNode = XElement.Parse("<Seminar />");
            if (seminarTimeData != null)
            {
                seminarNode.Add(new XElement("Location", new XCData(seminarTimeData.SeminarLocation)),
                    new XElement("Date", seminarTimeData.SeminarDate),
                    new XElement("Time", Time(seminarTimeData.Time)),
                    new XElement("Timezone", seminarTimeData.TimeZone),
                    new XElement("Latitude", seminarTimeData.MapLatitude),
                    new XElement("Longitude", seminarTimeData.MapLongitude),
                    new XElement("FriendlyName", seminarTimeData.SeminarFriendlyName),
                    new XElement("Street", seminarTimeData.Street),
                    new XElement("Street2", seminarTimeData.Street2),
                    new XElement("FullStreet", (seminarTimeData.Street + " " + seminarTimeData.Street2).Trim()),
                    new XElement("City", seminarTimeData.City),
                    new XElement("State", seminarTimeData.State),
                    new XElement("Zip", seminarTimeData.Zip),
                    new XElement("Country", seminarTimeData.Country),
                    new XElement("Hotel", seminarTimeData.Hotel),
                    new XElement("ParkingDetails", seminarTimeData.ParkingDetails),
                    new XElement("SeminarPhoneNumber", seminarTimeData.SeminarPhoneNumber),
                    new XElement("Speaker", seminarTimeData.Speaker),
                    new XElement("Title", seminarTimeData.Title),
                    new XElement("MapItLink", GetMapItLink(seminarTimeData))
                );
            }

            if (doc.Root != null)
                doc.Root.Add(seminarNode);
            else
                SiteExceptionHandler.HandleException("AdditionalLeads::CreateXML:: doc.Root was null. " + order.OrderID);
        }
        return doc;
    }

    private string GetMapItLink(SeminarTimeData seminarTimeData)
    {
        var mapItLink = new StringBuilder("/Shared/map.aspx?");
        if (seminarTimeData.MapLatitude == 0 && seminarTimeData.MapLongitude == 0)
        {
            mapItLink.AppendFormat("addr={0} {1}, {2} {3}", (seminarTimeData.Street + " " + seminarTimeData.Street2).Trim(), seminarTimeData.City, seminarTimeData.State, seminarTimeData.Zip);
        }
        else
        {
            mapItLink.AppendFormat("lat={0}&long={1}", seminarTimeData.MapLatitude, seminarTimeData.MapLongitude);
        }
        return mapItLink.ToString();
    }

    private string GetFormattedBody(XNode xml, XslCompiledTransform xsl)
    {
        var sb = new StringBuilder();
        var writer = XmlWriter.Create(sb, xsl.OutputSettings);
        if (writer == null)
        {
            throw new Exception("Failed to create writer. \n" + xml);
        }

        xsl.Transform(xml.CreateReader(), writer);
        writer.Close();
        return sb.ToString();
    }

    private string Time(short value)
    {
        var hour = value / 100;
        var minute = value % 100;

        return hour >= 12
            ? string.Format("{0}:{1:00} PM", hour == 12 ? hour : hour - 12, minute)
                   : string.Format("{0}:{1:00} AM", hour, minute);
    }

    public bool IsReusable
    {
        get { return true; }
    }

}
