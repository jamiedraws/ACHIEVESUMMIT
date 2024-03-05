using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dtm.Framework.ClientSites.Web;

namespace ACHIEVESUMMIT.Models
{
   
    public class ItemValidator
    {
        private static List<string> excludeProducts = DtmContext.CampaignProducts.Where(cp => cp.ProductTypeId == 0).Select(cp => cp.ProductCode).ToList();


        public bool HasItems(Dictionary<string,int> items)
        {
            var total = items.Where(ai => !excludeProducts.Contains(ai.Key)).Sum(ai => ai.Value);

            return total > 0;
        }

    }
}