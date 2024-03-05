using Dtm.Framework.ClientSites.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ACHIEVESUMMIT.PageHandlers
{
    public class ShoppingCartPageHandler : PageHandler
    {
        public override void PostProcessPageActions()
        {
            foreach (var item in GlobalPageHandler.bonusProducts)
            {
                OrderManager.SetProductQuantity(item.Key, DtmContext.ShoppingCart[item.Value].Quantity);
            }
        }
    }
}