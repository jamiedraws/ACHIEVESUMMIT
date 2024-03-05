<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<Dtm.Framework.ClientSites.Web.ClientSiteViewData>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%@ Import Namespace="Dtm.Framework.Models.Ecommerce" %>
    <%@ Import Namespace="Dtm.Framework.Base.Enums" %>
    <%@ Import Namespace="Dtm.Framework.ClientSites" %>

    <%=Html.Partial("OrderFlowPhase") %>

    <%
        var upgradeProp = "UpgradeTo";
        var downgradeProp = "DowngradeTo";
        var allReOfferProducts = DtmContext.CampaignProducts
            .Where(cp => cp.PropertyIndexer.Has("ReOffer") && cp.PropertyIndexer["ReOffer", false])
            .ToList();

        var reOfferProducts = new List<Dtm.Framework.Base.Models.CampaignProductView>();
        foreach (var product in allReOfferProducts)
        {
            var reofferWith = product.PropertyIndexer["OnlyReOfferWith", string.Empty];
            if (!string.IsNullOrWhiteSpace(reofferWith))
            {
                var offerWithList = reofferWith.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                if (DtmContext.Order.OrderItems.Any(oi => offerWithList.Contains(oi.CampaignProduct.ProductCode)))
                {
                    reOfferProducts.Add(product);
                }
                continue;
            }

            var noReOfferWith = product.PropertyIndexer["DontReOfferWith", string.Empty];
            if (!string.IsNullOrWhiteSpace(noReOfferWith))
            {
                var dontOfferWithList = noReOfferWith.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
                if (!DtmContext.Order.OrderItems.Any(oi => dontOfferWithList.Contains(oi.CampaignProduct.ProductCode)))
                {
                    reOfferProducts.Add(product);
                }
                continue;
            }

            reOfferProducts.Add(product);
        }

        var topProduct = reOfferProducts.FirstOrDefault(cp =>
        cp.PropertyIndexer.Has("ReOfferTop") && cp.PropertyIndexer["ReOfferTop", false]);
        if (topProduct != null)
        {
            reOfferProducts.Remove(topProduct);
            Html.RenderPartial("AddToCart", topProduct);
        }

        if (reOfferProducts.Any())
        {
    %>
    <div class="ad-header reOfferHeadline">
        <h2>Get Closer To The Action!</h2>
        <br />
        <h2><small>Upgrade Your Seats Now.</small></h2>

    </div>
    <%
        var mainProduct = DtmContext.Order.OrderItems.FirstOrDefault(oi => !string.Equals(oi.CachedProductInfo.ProductType, "None", StringComparison.InvariantCultureIgnoreCase));
        if (mainProduct != null)
        {


            foreach (var item in reOfferProducts)
            {
    %>
    <div class="reOfferProductCt">
        <%=Html.Partial("AddToCart", item, new ViewDataDictionary {
                        { "cssClasses", "card--mini" },
                        {"mainProduct", mainProduct}
                    }) %>
    </div>
    <%
            }
        }
    %>
    <input type="hidden" id="actionFrom" name="actionFrom" class="summaryCartParam" value="" />
    <input type="hidden" id="actionTo" name="actionTo" class="summaryCartParam" value="" />
    <input type="hidden" id="action" name="action" class="summaryCartParam" value="" />
    <%
        }
    %>
    <!--Contact Info-->
    <% 
        using (Html.BeginForm())
        {
    %>
    <div class="c-brand--form u-mar">
        <div class="c-brand--form__fieldset">
            <%= Html.ValidationSummary() %>
            <div class="c-brand--form__legend u-vw--100">
                <h3 class="c-brand--form__headline">Your Order Summary</h3>
            </div>

            <div class="c-brand--form__table">
                <%= Html.Partial("SummaryReview", Model) %>
                <%= Html.Partial("ReOfferTable") %>
            </div>

            <div class="o-grid u-vw--100 u-mar--vert fn--center">
                <input name="acceptOffer" type="submit" value="<%= SettingsManager.ContextSettings["SummaryReviewTable.SubmitButtonText", "Continue"] %>" class="button" />
                <p class="u-mar--vert fn--center">Please click "Place Your Order" button to place your order.</p>
                <img src="/shared/images/PositiveSSL_tl_trans.png?appV=<%= DtmContext.ApplicationVersion %>" alt="SSL" class="u-mar--center u-mar--horz" />
            </div>

        </div>
    </div>
    <%  } %>

    <%= Html.Partial("_Seating") %>
    <script defer type="text/javascript" src="/js/SummaryReviewCartEngine.js?v=100"></script>
</asp:Content>
