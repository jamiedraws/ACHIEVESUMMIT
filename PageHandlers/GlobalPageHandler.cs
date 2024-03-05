using System;
using System.Web;
using System.Web.Mvc;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.Extensions;
using System.Text.RegularExpressions;
using Dtm.Framework.Models.Ecommerce;
using Dtm.Framework.ClientSites;
using ACHIEVESUMMIT.Models;
using ACHIEVESUMMIT.Models.Interfaces;
using System.Collections.Generic;
using System.Linq;

namespace ACHIEVESUMMIT.PageHandlers
{
    public class GlobalPageHandler : PageHandler
    {
        public static Dictionary<string, string> bonusProducts = new Dictionary<string, string> {
            {"GOLDFREE", "GOLD" },
            {"VIPFREE", "VIP" }
        };

        #region " Overrides... "
        public override void PostValidate(ModelStateDictionary modelState)
        {
            base.PostValidate(modelState);
            if(DtmContext.Page.IsStartPageType)
            {
                var itemValidator = new ItemValidator();
                if (!itemValidator.HasItems(ActionItems.ToDictionary(ai => ai.Key, ai => ai.Value)))
                {
                    ModelState.AddModelError("Form", "Please select a ticket");
                }
            }
        }

        public override void PostProcessPageActions()
        {
            if(DtmContext.Page.IsStartPageType && !string.Equals(DtmContext.Page.PageCode, "PaymentForm", StringComparison.InvariantCultureIgnoreCase))
            {
                if(DtmContext.Version >= 4)
                {
                    var actionCode = Form["ActionCode1"] as string ?? string.Empty;

                    if (!string.IsNullOrEmpty(actionCode))
                    {
                        var productsToRemove = DtmContext.ShoppingCart.Where(sc => sc.ProductCode != actionCode && sc.CampaignProduct.ProductTypeId != 0).Select(sc => sc.ProductCode).ToList();
                        foreach (var product in productsToRemove)
                        {
                            OrderManager.SetProductQuantity(product, 0);
                        }
                    }
                }

                foreach (var bonus in bonusProducts)
                {
                    OrderManager.SetProductQuantity(bonus.Key, Order.Items[bonus.Value].Quantity);
                }

                var offerItems = Order.OrderItems.Where(oi => oi.CachedProductInfo.ProductCode.Contains(DtmContext.OfferCode) && oi.CachedProductInfo.ProductTypeId != 0).ToList();

                foreach (var item in offerItems)
                {
                    OrderManager.UpgradeProduct(item.CachedProductInfo.ProductCode, item.ProductSku);
                }
            }
        }

        public override void PostSetOrderStatus()
        {
            if (DtmContext.Page.IsStartPageType && !string.Equals(DtmContext.Page.PageCode, "PaymentForm", StringComparison.InvariantCultureIgnoreCase))
            {
                Order.OrderStatusId = 1;
            }
        }

        #endregion
    }
}
