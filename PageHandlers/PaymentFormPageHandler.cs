using ACHIEVESUMMIT.Models;
using ACHIEVESUMMIT.Models.Interfaces;
using Dtm.Framework.ClientSites;
using Dtm.Framework.ClientSites.Web;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ACHIEVESUMMIT.PageHandlers
{
    public class PaymentFormPageHandler : PageHandler
    {
        private string FormType { get; set; }
        private ILocationEngine LocationEngine { get; set; }

        public PaymentFormPageHandler()
        {
            Dictionary<string, ILocationEngine> engineMap = new Dictionary<string, ILocationEngine>()
            {
                { "UK", new UnitedKingdomEngine() },
                { "CA", new CanadaEngine() },
                { "US-Short", new UnitedStatesEngine() },
                { "CA-Short", new CanadaEngine() },
                { "CA-Long", new CanadaEngine() }
            };

            FormType = SettingsManager.ContextSettings["Seminar.Template.Form.FormType--Form--", "US-Short"];

            if (engineMap.ContainsKey(FormType))
                LocationEngine = engineMap[FormType];
            else
                LocationEngine = engineMap["US-Short"];
        }

        #region " Overrides... "
        public override void PostValidate(ModelStateDictionary modelState)
        {
            if (DtmContext.Order.PaymentType == Dtm.Framework.Base.Enums.PaymentType.Card)
            {
                modelState = LocationEngine.GetModelErrors(modelState, Form, PostData);
            }
        }

        public override void BeginRequest(HttpRequestBase request, HttpResponseBase response, ref string pageCode)
        {
            base.BeginRequest(request, response, ref pageCode);

            if (string.Equals(Request.HttpMethod, "GET", System.StringComparison.InvariantCultureIgnoreCase))
            {
                var itemValidator = new ItemValidator();
                if (DtmContext.Order != null && DtmContext.Order.OrderStatusId == 3)
                {
                    response.Redirect(GetUrl(request, "Confirmation"));
                }
                else if (DtmContext.Order == null || DtmContext.Order.OrderID == 0 || DtmContext.Order.OrderItems == null || !DtmContext.Order.OrderItems.Any()
                    || !itemValidator.HasItems(DtmContext.Order.OrderItems.ToDictionary(oi => oi.CachedProductInfo.ProductCode, oi => oi.Quantity)))
                {
                    response.Redirect(GetUrl(request, "Index"));
                }
            }
        }
        #endregion

        private string GetUrl(HttpRequestBase request, string pageCode)
        {
            var url = string.Format("{0}{1}", pageCode, DtmContext.ApplicationExtension);
            if (request.Url != null)
            {
                var query = request.Url.Query == null ? string.Empty : request.Url.Query.ToString();

                url = url + query;
            }

            return url;
        }
    }
}
