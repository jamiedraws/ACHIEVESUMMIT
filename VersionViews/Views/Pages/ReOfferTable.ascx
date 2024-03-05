<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce.Repositories" %>
<%@ Import Namespace="Dtm.Framework.Base.TokenEngines" %>
<%@ Import Namespace="Dtm.Framework.Base.Models" %>

<%

    var categoryProducts = DtmContext.CampaignProducts
              .Where(cp => cp.CategoryIndexer.Has("ReOfferTable"))
              .ToList();

    if (categoryProducts.Any())
    {

%> 
<div class="c-brand--form__legend u-vw--100">
    <h3 class="c-brand--form__headline">Add Additional Tickets</h3>
</div>

<div class="c-brand--form__table">
<table class="orderItemsTable c-brand--rebuttal c-brand--upsell c-brand--table  c-brand--table--remove--labels c-brand--form u-vw--100" cellpadding="3" cellspacing="0" border="0">
    <tbody>
        <%
            var count = DtmContext.Order.OrderItems.Count() + 100;

            foreach (var product in categoryProducts)
            {
                var noRebuttalWithList = product.PropertyIndexer["NoRebuttalWith", ""];
                var onlyRebuttalWithList = product.PropertyIndexer["OnlyRebuttalWith", ""];
                var showAction = 1;

                //NoRebuttalWith Logic
                if (!string.IsNullOrEmpty(noRebuttalWithList))
                {
                    var tempWithList = noRebuttalWithList.Split(',');
                    foreach (var p in tempWithList)
                    {
                        if (DtmContext.Order.OrderItems.Any(z => z.CachedProductInfo.ProductCode == p))
                        {
                            showAction = 0;
                        }
                    }
                }

                //OnlyRebuttalWith Logic
                if (!string.IsNullOrEmpty(onlyRebuttalWithList))
                {
                    var tempOnlyList = onlyRebuttalWithList.Split(',');
                    var actionCount = 0;
                    foreach (var p in tempOnlyList)
                    {
                        if (DtmContext.Order.OrderItems.Any(z => z.CachedProductInfo.ProductCode == p))
                        {
                            actionCount++;
                        }
                    }
                    if (actionCount == 0)
                    {
                        showAction = 0;
                    }
                }

                //if (DtmContext.Order.OrderItems.Any(x => x.CachedProductInfo.ProductCode == product.ProductCode))
                //{
                //    showAction = 0;
                //}
                if (showAction > 0)
                {
                    count++;
                    var model = new Dictionary<int, Dtm.Framework.Base.Models.CampaignProductView>() { { count, product } };
                    Html.RenderPartial("ReOfferTableRow", model);
                }
            }

        %>
    </tbody>
</table>
</div>
<%  } %>
<!-- // Custom Order Table -->
