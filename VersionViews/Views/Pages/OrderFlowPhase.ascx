<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<% 
    var layoutMode = SettingsManager.ContextSettings["Upsell.LayoutMode", ""];

    if (layoutMode.ToLower() == "orderflowphase") {
        var pageTypeId = DtmContext.Page.PageTypeId;
        var pageCode = DtmContext.Page.PageCode;
        var phase = string.Empty;
        var showOrderNumberText = false;
        //Upsell page type 2
        //

        if (pageTypeId == 2)
        {
            phase = "upsell";
        }
        else if (string.Equals(pageCode, "PaymentForm", StringComparison.InvariantCultureIgnoreCase))
        {
            phase = "payment";
        }
        else if (string.Equals(pageCode, "ReviewPage", StringComparison.InvariantCultureIgnoreCase) || string.Equals(pageCode, "confirmationReview", StringComparison.InvariantCultureIgnoreCase))
        {
            phase = "review";
        }
        else
        {
            phase = "conf";
        }

        //Check for first upsell page
        var firstPageVisit = DtmContext.RoutingHistory.OrderByDescending(r => r.AddDate).FirstOrDefault(rh => rh.TargetPageId == DtmContext.Page.PageId);
        if (firstPageVisit != null)
        {
            var lastRoute = DtmContext.RoutingHistory.Where(rh => rh.AddDate <= firstPageVisit.AddDate).OrderByDescending(r => r.AddDate).FirstOrDefault();
            if (lastRoute != null)
            {
                var lastPage = DtmContext.CampaignPages.FirstOrDefault(cp => cp.PageId == lastRoute.PageId);
                if (lastPage != null)
                {
                    showOrderNumberText = lastPage.IsStartPageType;
                }
            }
        }


%>
<link rel="stylesheet" href="/css/order-progress.css">
<style>
    .c-phase__circle--<%= phase %> {
        background: #ee5a23;
    }
</style>
<section class="c-brand--upsell c-phase">
    <div class="c-phase__group">
        <figure class="c-phase__status">
            <div class="c-phase__circle c-phase__circle--payment">
                <img src="/images/icon-dollar.svg" alt="">
            </div>
            <figcaption>Payment Information</figcaption>
        </figure>
    
        <figure class="c-phase__status">
            <div class="c-phase__circle c-phase__circle--review">
                <img src="/shared/images/order-progress/receipt.svg" alt="">
            </div>
            <figcaption>Review Your Order</figcaption>
        </figure>
    
        <figure class="c-phase__status">
            <div class="c-phase__circle c-phase__circle--conf">
                <img src="/images/icon-checkmark.svg" alt="">
            </div>
            <figcaption>Order Confirmation</figcaption>
        </figure>
    </div>

</section>

<% } %>