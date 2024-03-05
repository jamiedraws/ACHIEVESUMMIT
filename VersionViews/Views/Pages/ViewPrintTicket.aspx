<%@ Page Title="Dotza" Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<ClientSiteViewData>" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.ClientSites.Web.Controllers" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="ACHIEVESUMMIT.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   
<%

    var orderId = (Request.QueryString.Count == 0) ? string.Empty : Request.QueryString["oid"];
    var orderIdNumeric = 0;
    var response = string.Empty;
    SeminarOrder seminarOrder = null;

    int.TryParse(orderId, out orderIdNumeric);
    
    if (orderIdNumeric != 0)
    {
        var splitString = "/" + DtmContext.Page.PageCode;
        var servicePath = "/Services/GetSeminarOrder.ashx?oid=";
        var url = Request.Url.AbsoluteUri.Split(new string[] { splitString }, StringSplitOptions.None)[0] + servicePath + orderId;
        WebRequest webRequest = WebRequest.Create(url);
        webRequest.Method = "GET";

        try
        {
            using (var webResponse = webRequest.GetResponse())
            {
                var stream = webResponse.GetResponseStream();
                if (stream != null)
                {
                    using (var reader = new StreamReader(stream))
                    {
                        response = reader.ReadToEnd();
                    }
                }
            }
        }
        catch (WebException webException)
        {
            string responseText = "";

            if (webException.Response != null)
            {
                try
                {
                    using (var reader = new StreamReader(webException.Response.GetResponseStream()))
                    {
                        responseText = reader.ReadToEnd();
                    }
                }
                catch (Exception e)
                {
                    new SiteExceptionHandler(e);
                }
            }
            new SiteExceptionHandler(responseText + "\n" + webException);
        }


        seminarOrder = JsonConvert.DeserializeObject<SeminarOrder>(response);       
    }


    if (seminarOrder != null && seminarOrder.Order.OrderItems != null)
    {
        var seminarItem = seminarOrder.Order.OrderItems.Where(oi => oi.CachedProductInfo.ProductTypeId == 0).FirstOrDefault();
        var items =  seminarOrder.Order.OrderItems.Where(oi => oi.CachedProductInfo.ProductTypeId != 0 && !oi.CachedProductInfo.ProductCode.Contains("FREE")).ToList();
        var seminarViewData = SeminarControllerUtil.LoadSeminars(seminarOrder.OfferCode, seminarOrder.VersionNumber);

        if (seminarItem != null && items.Any())
        {
            var Use24HourClock = SettingsManager.ContextSettings["Seminar.Template.Use24HourFormat", false];
            var timeFormatString = Use24HourClock ? "H:mm" : "h:mm tt";
            string productCode = seminarItem.CachedProductInfo.ProductCode;
            var location = seminarViewData.GetSeminarDateByProductCode(productCode);
            var time = seminarViewData.GetSeminarTimeByProductCode(productCode);
            var openTime = time.CampaignProduct.PropertyIndexer.Has("OpenTime") ? time.CampaignProduct.PropertyIndexer["OpenTime"] : string.Empty;
            var endTime = time.CampaignProduct.PropertyIndexer.Has("EndTime") ? time.CampaignProduct.PropertyIndexer["EndTime"] : string.Empty;
            var seminarTimeZone = time.CampaignProduct.TimeZoneDisplayId;
            var timeZone = !string.IsNullOrWhiteSpace(seminarTimeZone) ? TimeZoneInfo.FindSystemTimeZoneById(seminarTimeZone)
                    : TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");

            var hours = time.Time / 100;
            var mins = time.Time % 100;
            var seminarDate = location.SeminarDate.AddHours(hours).AddMinutes(mins);
%>

<div id="ticket" data-print class="print-ticket">
    <link rel="stylesheet" href="/css/print-ticket.css?v=1">
    <%
        foreach (var item in items)
        {
            var ticketType = item.CachedProductInfo.ProductCode;
            var bogoProp = item.CachedProductInfo.PropertyIndexer.Has("IsBogo") ? item.CachedProductInfo.PropertyIndexer["IsBogo"] : "false";

            bool isBogo = false;
            bool.TryParse(bogoProp, out isBogo);
            for (int i = 0; i < (isBogo ? item.Quantity * 2 : item.Quantity); i++)
            {
    %>
    <div class="print-ticket__group print-ticket__group--border">
        <div class="print-ticket__item">
            <div class="o-pos c-ticket c-ticket--horz">
                <hr class="o-pos__abs--center u-vw--100">
                <h3 class="o-pos u-vw--10 u-mar--center fn--center icon-ticket"></h3>
            </div>

            <div class="print-ticket__group">
                <div class="print-ticket__item">
                    <div class="print-ticket__entry">
                        <strong>Ticket No.</strong>
                        <span><%=seminarOrder.Order.OrderID %></span>
                    </div>

                    <div class="print-ticket__entry">
                        <strong>Ticket Type:</strong>
                        <span><%=ticketType %></span>
                    </div>

                    <div class="print-ticket__entry">
                        <strong>Name:</strong>
                        <span><%=seminarOrder.Order.BillingFirstName %> <%=seminarOrder.Order.BillingLastName %></span>
                    </div>
                </div>
                <div class="print-ticket__item">
                    <div class="print-ticket__entry">
                        <strong>Event:</strong>
                        <span>
                            <%= location.SeminarLocation %><br>
                            <%= location.Street %><br>
                            <% if (!String.IsNullOrEmpty(location.Street2))
                                { %>
                            <%= location.Street2 %><br>
                            <% } %>
                            <%= location.City %>, <%= location.State %> <%= location.Zip %>
                        </span>
                    </div>

                    <div class="print-ticket__entry">
                        <strong>Date:</strong>
                        <span><%=location.SeminarFriendlyName %></span>
                    </div>

                    <div class="print-ticket__entry">
                        <strong>Time:</strong>
                        <span><%=seminarDate.Hour.ToString("##") + seminarDate.ToString("tt", System.Globalization.CultureInfo.InvariantCulture).ToLower() %> - <%if (!string.IsNullOrEmpty(endTime))
                                                                                                                                                                    { %> <%=endTime %> <%} %> <%=timeZone.StandardName %></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="print-ticket__item">
            <img class="print-ticket__logo" src="/images/logos/wealth-achievement-summit-bw.svg" alt="Wealth Achievement Summit">
        </div>
    </div>
    <%
            }
        }
    %>
    <div class="print-ticket__item c-brand--confirm">
        <div class="fn--center @print-only-hide o-pos u-mar--top">
            <a href="javascript:;" onclick="window.print();" class="o-box--btn--icon fn--decor--none fx--animate"><span class="icon-printer u-mar--right"></span>Print Your Ticket</a>
        </div>
    </div>
</div>

<% 
        }
    }
%>

</asp:Content>
