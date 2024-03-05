<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.CampaignProductView>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="ACHIEVESUMMIT.Models" %>
<% 
    var item = Model;
    var priceHeadLineOverride = ViewData["PriceHeadline"] as string;
    var image = item.PropertyIndexer["Image", string.Empty];
    var imageSize = item.PropertyIndexer["ImageSize", string.Empty];
    var imageAlt = item.PropertyIndexer["ImageAlt", item.Title];
    var shopImageSrc = "/images/upsells/shop/" + image;

    UpsellImage upsellImage = new UpsellImage()
    {
        Name = image,
        Size = imageSize,
        Alt = imageAlt,
        Src = shopImageSrc
    };

    var priceHeadline = string.IsNullOrWhiteSpace(priceHeadLineOverride)
        ? "Your Price Today"
        : priceHeadLineOverride;

    var cssClasses = ViewData["cssClasses"] as string ?? string.Empty;

    var mainProduct = ViewData["mainProduct"] as OrderItem ?? new OrderItem();

%>

<% // RUSH Shipping Html Goes here %>

<% // QTY buttons and Add To Cart Html Goes here %>
<section class="card card--contain <%= cssClasses %> upgrade<%=item.ProductCode %>">


    <div class="card__item card__content">
        <div class="card__media" data-sku="<%=item.ProductCode %>">
            <%= Html.Partial("_UpsellImage", upsellImage) %>
            <span><%= item.ProductCode %></span>
        </div>
        <div class="card__copy" >
            <%=item.ProductName %>
        </div>
        <hr>
        <div class="card__ad">
            <div class="card card--cart">
                <div class="card__item card__order">
                    <a href="#seating" class="card__link-image has-fancybox">
                        <img src="/images/icon-seating-chart.png" alt="View seating chart">
                    </a>
                    <a href="#" id="<%=item.ProductCode %>ReOfferProduct" data-from="<%=mainProduct.CachedProductInfo.ProductCode %>" data-to="<%=item.ProductCode %>" data-action="upgrade" class="btn btn--card" aria-label="Upgrade">Upgrade Tickets</a>
                </div>
            </div>
        </div>
    </div>
</section>
