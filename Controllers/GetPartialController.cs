using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Dtm.Framework.Base.Controllers;
using Dtm.Framework.ClientSites.Web;

namespace ACHIEVESUMMIT.Controllers
{
    public class GetPartialController : DtmContextController
    {
        [HttpGet]
        public string GetPartialView(string name, Guid covid)
        {
            var versionContext = DtmContext.CampaignOfferVersions.Where(v => v.OfferVersionId == covid).FirstOrDefault();
            var domain = Request.Url.DnsSafeHost + (Request.Url.DnsSafeHost == "localhost" ? ":" + Request.Url.Port : string.Empty);
            
            ViewData["RecaptureUrl"] = Request.Url.Scheme + "://" + domain;
            ViewData["IsRecapture"] = true;
            DtmContext.PageCode = "ProcessPayment";
            DtmContext.Page = DtmContext.CampaignPages.Where(cp => cp.PageCode == DtmContext.PageCode).FirstOrDefault();
            DtmContext.Version = versionContext.VersionNumber;
            DtmContext.VersionId = versionContext.OfferVersionId;
            DtmContext.OfferCode = versionContext.OfferCode;

            using (var sw = new StringWriter())
            {
                var viewResult = ViewEngines.Engines.FindPartialView(ControllerContext, name);
                var viewContext = new ViewContext(ControllerContext, viewResult.View, ViewData, TempData, sw);
                viewResult.View.Render(viewContext, sw);

                return sw.GetStringBuilder().ToString();
            }
        }

    }
}