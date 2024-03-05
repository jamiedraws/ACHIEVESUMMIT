using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ACHIEVESUMMIT.Models;
using Dtm.Framework.ClientSites.Web;

namespace ACHIEVESUMMIT.PageHandlers
{
    public class ReviewPagePageHandler : PageHandler
    {
       
        public override void PostValidate(ModelStateDictionary modelState)
        {
            base.PostValidate(modelState);
            var itemValidator = new ItemValidator();
            if (!itemValidator.HasItems(ActionItems.ToDictionary(ai=> ai.Key, ai=> ai.Value)))
            {
                modelState.AddModelError("Review","Please select at least one ticket");
            }
        }


        public override void PostProcessPageActions()
        {
            base.PostProcessPageActions();


            var productCode = Request.Params["itemId"] as string ?? string.Empty;
            var quantityParam = Request.Params["quantity"] as string ?? string.Empty;

            if(!string.IsNullOrEmpty(productCode))
            {
                int quantity = 0;
                int.TryParse(quantityParam, out quantity);

                OrderManager.SetProductQuantity(productCode, quantity);
            }

            
            var actionTo = Request.Params["summaryCartParam_actionTo"] as string ?? string.Empty;
            var actionFrom = Request.Params["summaryCartParam_actionFrom"] as string ?? string.Empty;
            var action = Request.Params["summaryCartParam_action"] as string ?? string.Empty;

            if (!string.IsNullOrEmpty(actionTo) && !string.IsNullOrEmpty(actionFrom))
            {
                var cartItems = (Request.Params["CartItems"] ?? string.Empty)
                  .Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries)
                  .ToList();
                var bonusFromProduct = GlobalPageHandler.bonusProducts.Where(v => string.Equals(v.Value, actionFrom, StringComparison.InvariantCultureIgnoreCase)).ToDictionary(v=> v.Key, v=> v.Value);
                var bonusToProduct = GlobalPageHandler.bonusProducts.Where(v => string.Equals(v.Value, actionTo, StringComparison.InvariantCultureIgnoreCase)).ToDictionary(v => v.Key, v => v.Value);
                
                if (bonusFromProduct.Any() && !bonusToProduct.Any())
                {
                    cartItems.Remove(bonusFromProduct.FirstOrDefault().Key);
                }else if ((bonusToProduct.Any() && !bonusFromProduct.Any()))
                {
                    cartItems.Add(bonusToProduct.FirstOrDefault().Key);
                }else if (bonusFromProduct.Any() && bonusToProduct.Any())
                {
                    cartItems.Remove(bonusFromProduct.FirstOrDefault().Key); 
                    cartItems.Add(bonusToProduct.FirstOrDefault().Key);
                }

                OrderManager.SetProductQuantity(actionFrom, Order.Items[actionFrom].Quantity);
                OrderManager.UpgradeProduct(actionFrom, actionTo);

                if(cartItems.Contains(actionFrom))
                {
                    cartItems.Remove(actionFrom);
                }

                if(!cartItems.Contains(actionTo))
                {
                    cartItems.Add(actionTo);
                }

                ViewData["NewCartItems"] = string.Join(",", cartItems);
            }

            foreach (var bonus in GlobalPageHandler.bonusProducts)
            {
                OrderManager.SetProductQuantity(bonus.Key, Order.ContextOrderItems.Where(oi => oi.CachedProductInfo.ProductCode == bonus.Value).Sum(oi => oi.Quantity));
            }


        }

    }
}