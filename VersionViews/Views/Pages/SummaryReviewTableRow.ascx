<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="System.Globalization" %>
<%  //Columns to show
    bool showItemColumn = ViewData["ShowItem"] == null ? true : (bool)ViewData["ShowItem"];
    bool showDescriptionColumn = ViewData["ShowDescription"] == null ? true : (bool)ViewData["ShowDescription"];
    bool showQuantityColumn = ViewData["ShowQuantity"] == null ? true : (bool)ViewData["ShowQuantity"];
    bool showSubtotalColumn = ViewData["ShowSubtotal"] == null ? true : (bool)ViewData["ShowSubtotal"];
    bool showShippingColumn = ViewData["ShowShipping"] == null ? false : (bool)ViewData["ShowShipping"];

    //Product Code
    var item = (OrderItem)ViewData["OrderItem"];
    var product = item.CachedProductInfo;
    var count = (int)ViewData["Index"];
    var productCode = item.CachedProductInfo.ProductCode;
    var fromProductCode = productCode; // Used to target From Product when upgrading/downgrading
    var qty = item.Quantity;
    var minQty = item.CachedProductInfo.MinQuantity;
    var maxQty = item.CachedProductInfo.MaxQuantity;
    var parentProduct = DtmContext.CampaignProducts.FirstOrDefault(cp => cp.RelatedProducts.Any(rp => rp.IsLineItem && rp.CampaignProductId == item.CampaignProductId));
    var productType = item.CachedProductInfo.ProductType;
    if (parentProduct != null) { product = parentProduct; fromProductCode = product.ProductCode; } // If Is Line Item, use Parent's Properties

    //Properties
    var defaultUpgradeText = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.UpgradeText", "Upgrade<br/>to deluxe offer"];
    var defaultDowngradeText = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.DowngradeText", "Downgrade<br/>to main offer"];
    var defaultRemoveText = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.RemoveText", "Remove"];
    var removeText = product.PropertyIndexer["RemoveText"] ?? defaultRemoveText;
    var defaultAddText = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.AddText", "Add"];
    var addText = product.PropertyIndexer["AddText"] ?? defaultAddText;
    var propNoEdit = product.PropertyIndexer["NoEdit", false];
    var propRemoveNoEdit = product.PropertyIndexer["RemoveNoEdit", false];
    var propDowngradeTo = product.PropertyIndexer["DowngradeTo"];
    var propUpgradeTo = product.PropertyIndexer["UpgradeTo"];
    var propChangeWith = product.PropertyIndexer["ChangeWith"];
    var propRemoveWith = product.PropertyIndexer["RemoveWith"];
    var propHideChangeAction = product.PropertyIndexer["HideChangeAction", false]
                                || item.CachedProductInfo.PropertyIndexer["HideChangeAction", false];
    var propHideRow = product.PropertyIndexer["HideProduct", false];
    var propHideAt0 = product.PropertyIndexer["HideAt0", false];
    var propCanEditQuantity = product.PropertyIndexer["CanEditQuantity", true];
    var upgradeText = product.PropertyIndexer["UpgradeText"] ?? defaultUpgradeText;
    var downgradeText = product.PropertyIndexer["DowngradeText"] ?? defaultDowngradeText;
    var validateUpsell = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.ValidateUpsell", true];
    var isCustomUpsell = product.PropertyIndexer["CustomUpsell", false];
    var preferredActionString = product.PropertyIndexer["PreferredActions", ""].Replace(" ", String.Empty);
    var preferredActions = preferredActionString.ToUpper().Split(',');
    var cartImageProperty = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.CartImageProperty", "SummaryReviewCartImage"];
    var enableCartImage = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.EnableCartImage", false];

    var changeActionStyle = propHideChangeAction ? "display:none" : "display:inline";

    var culture = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.CultureInfo", "en-US"];

    //Determine whether or not to show or hide the product code.
    var hideRow = ((propHideRow && !DtmContext.Page.PageCode.ToUpper().Contains("CONFIRMATION")) || (propHideAt0 && qty == 0)) ? "display:none" : "";
    var hideRowBool = ((propHideRow && !DtmContext.Page.PageCode.ToUpper().Contains("CONFIRMATION")) || (propHideAt0 && qty == 0));

    var isConfirmationView = (Dtm.Framework.ClientSites.Web.DtmContext.Page.PageCode).ToUpper().Contains("CONFIRMATION");
    int temp;
    var lineItemIndex = Regex.Match(productCode, "[_]LI(?<lineItemIndex>\\d)+$", RegexOptions.IgnoreCase).Groups["lineItemIndex"].Value;
    if ((int.TryParse(lineItemIndex, out temp) && temp > 1) || product.ProductType == "Shipping" || product.ProductType == "None" || product.ProductType == "Fee" || propRemoveNoEdit)
    {
        propNoEdit = true;
    }

    var showDropdownQty = !propNoEdit && propCanEditQuantity;

    var wasUpgradedTo = false;
    var wasUpgradedFrom = false;
    var wasAddedOnUpsell = false;
    var wasUpgradedOnUpsell = ((Func<bool>)(() =>
    {
        var orderActions = DtmContext.IsMainOfferComplete
                ? DtmContext.Order.Actions
                    .Select(a => new { a.CampaignProductId, a.OfferResponse, a.PageId, a.AddDate })
                    .ToList()
                : DtmContext.Order.OrderActions
                    .Select(a => new { a.CampaignProductId, a.OfferResponse, a.PageId, a.AddDate })
                    .ToList();
        var pageIds = orderActions
            .Where(oa => oa.CampaignProductId == product.CampaignProductId)
            .OrderBy(oa => oa.AddDate)
            .Select(oa => oa.PageId);
        var hasAcceptedPageOffer = orderActions
            .Any(oa => pageIds.Contains(oa.PageId) && oa.OfferResponse == OfferResponse.Accept.ToString());
        if (!hasAcceptedPageOffer) return false;

        var repo = new Dtm.Framework.Models.Ecommerce.Repositories.UpsellRepository();
        var upsells = pageIds
            .Select(repo.GetByPageId);

        wasUpgradedTo = upsells
            .SelectMany(u => u.UpsellActions)
            .Any(ua => ua.UpsellActionTypeId == 1 && ua.UpsellActionProductIds.Any(id => id == product.CampaignProductId));
        wasUpgradedFrom = upsells
            .SelectMany(u => u.UpsellActions)
            .Any(ua => ua.UpsellActionTypeId == 1 && ua.UpsellActionTargetProductIds.Any(id => id == product.CampaignProductId));
        wasAddedOnUpsell = upsells
            .SelectMany(u => u.UpsellActions)
            .Any(ua => (ua.UpsellActionTypeId == 0 || ua.UpsellActionTypeId == 3) && ua.UpsellActionProductIds.Any(id => id == product.CampaignProductId));
        var hasUpsellActionUpgrade = wasUpgradedTo || wasUpgradedFrom;

        if (!hasUpsellActionUpgrade) return false;

        return true;
    }))();

    if ((wasUpgradedOnUpsell && wasUpgradedTo) || isCustomUpsell)
    {
        productType = "Upsell";
    }



    var wasTakenOnUpsell = wasUpgradedOnUpsell || wasAddedOnUpsell || isCustomUpsell;

    var canUpgrade = ((Func<bool>)(() =>
    {
        var hasUpgradeToProperty = product.PropertyIndexer["UpgradeTo"] != null;
        if (!hasUpgradeToProperty) return false;

        var hasChangeWith = product.PropertyIndexer["ChangeWith"] != null;
        if (hasChangeWith && validateUpsell)// Validate Upsell
        {
            return wasUpgradedOnUpsell;
        }
        return true;
    }))();
    var canDowngrade = ((Func<bool>)(() =>
    {
        var hasUpgradeToProperty = product.PropertyIndexer["DowngradeTo"] != null;
        if (!hasUpgradeToProperty) return false;

        var hasChangeWith = product.PropertyIndexer["ChangeWith"] != null;
        if (hasChangeWith && validateUpsell)// Validate Upsell
        {
            return wasUpgradedOnUpsell;
        }
        return true;
    }))();

    if (isConfirmationView)
    {
        propNoEdit = true;
        showDropdownQty = false;
        canUpgrade = false;
        canDowngrade = false;
        propRemoveNoEdit = false;
        propHideRow = false;
    }


    var cartImageHtml = string.Empty;
    if(enableCartImage)
    {
        var cartImage = product.PropertyIndexer[cartImageProperty] ?? string.Empty;

        if(!string.IsNullOrWhiteSpace(cartImage))
        {
            cartImageHtml = string.Format(@"<td class='c-brand--item'>
                <div class='c-brand--item__group'>
                    <img src='{0}' class='c-brand--item__img summaryReviewCartImage' id='{1}CartImage' />
                    <span class='c-brand--item__text'>{{0}}</span>
                </div>
            </td>", cartImage, item.CachedProductInfo.ProductSku);
        }
    }

%>

<tr data-count="<%=count %>" style="<%=hideRow%>">

    <%if (showItemColumn)
        { 
            if (!string.IsNullOrWhiteSpace(cartImageHtml) && !DtmContext.IsMobile)
            {
        %>
                <%=string.Format(cartImageHtml, item.CachedProductInfo.ProductSku) %>
        <%
            } else {
        %>
                <td data-sku="<%= item.CachedProductInfo.ProductSku %>"><span class="orderItemsLabel"><%= item.CachedProductInfo.ProductSku %></span></td>
        <% } 
        }
    %>

    <%if (showDescriptionColumn)
        { 
            if (!string.IsNullOrWhiteSpace(cartImageHtml) && DtmContext.IsMobile) 
            {
        %>
                <%=string.Format(cartImageHtml, item.Description) %>
        
        <%
            } else {
        %>
                <td><%= item.Description %></td>
        <% } 
        }
    %>

    <%if (showQuantityColumn)
        { %>
    <td align="right">
        <%=Html.Hidden("ActionCode" + count, item.CachedProductInfo.ProductCode)%>
        <%if (item.ProductAttributeValueId.HasValue)
            { %>
        <%=isConfirmationView ? new MvcHtmlString(string.Empty) : Html.Hidden("ActionAttribute" + count, item.ProductAttributeValue.ProductCode)%>
        <%} %>

        <% if (showDropdownQty)
            {
                var maximumQuantity = (minQty == 0) ? (maxQty + 1) : maxQty;
                var actionQuantityOptions = Enumerable.Range(minQty, maximumQuantity)
                    .Select(i => new SelectListItem
                    {
                        Value = i.ToString(),
                        Text = i.ToString(),
                        Selected = i == qty
                    })
                    .ToList();%>
        <%= Html.DropDownList("ActionQuantity" + count, actionQuantityOptions,
            new {
                pType = productType,
                takenOnUpsell = wasTakenOnUpsell,
                onchange = string.Format("Update('{0}',this.value, this);", productCode)
            })%>
        <%}
            else
            {%>
        <%=qty%>
        <%= isConfirmationView ? new MvcHtmlString(string.Empty) : Html.Hidden("ActionQuantity" + count, qty, new { pType = productType, takenOnUpsell = wasTakenOnUpsell })%>
        <% } %>
    </td>
    <%}%>

    <%if (showSubtotalColumn)
        { %>
    <td align="right"><%=string.Format(new CultureInfo(culture), "{0:C}", item.Price * qty)%></td>
    <%}%>

    <%if (showShippingColumn)
        {%>
    <td align="right"><%=string.Format(new CultureInfo(culture), "{0:C}", item.Shipping * qty)%></td>
    <%}%>
</tr>
<% if (propRemoveNoEdit || canDowngrade || canUpgrade)
    {
        var preferredOverride = propHideChangeAction &&
               (Array.FindIndex(preferredActions, x => x == "REMOVENOEDIT" || x == "UPGRADE" || x == "DOWNGRADE") >= 0);
        var rowStyle = (hideRowBool || propHideChangeAction) && !preferredOverride ? "display:none;" : "";
        var removeStyle = !propHideChangeAction ||
            (propHideChangeAction && (Array.FindIndex(preferredActions, x => x == "REMOVENOEDIT") >= 0)) ? "inline" : "none;";
        var upgradeStyle = !propHideChangeAction ||
            (propHideChangeAction && (Array.FindIndex(preferredActions, x => x == "UPGRADE") >= 0)) ? "inline" : "none;";
        var downgradeStyle = !propHideChangeAction ||
            (propHideChangeAction && (Array.FindIndex(preferredActions, x => x == "DOWNGRADE") >= 0)) ? "inline" : "none;";
%>
<tr class="c-brand--table__checkboxes table__support--prop" style="<%=rowStyle%>">
    <td class="prop__hide--html"></td>
    <td colspan="4" class="prop__hide--label">
        <% if (propRemoveNoEdit && qty == 0)
            {%>
        <input type="checkbox" style="display: <%=removeStyle%>"
            id="AddBox_<%=productCode%>" name="AddBox" value="true"
            onchange="Update('<%=productCode%>', 1, this);" />
        <label for="AddBox_<%=productCode%>"><%=addText%></label>
        <%}
            else if (propRemoveNoEdit)
            {%>
        <input type="checkbox" style="display: <%=removeStyle%>"
            id="RemoveBox_<%=productCode%>" name="RemoveBox" value="true"
            data-removewith="<%=propRemoveWith %>"
            onchange="Update('<%=productCode%>', 0, this);" />
        <label for="RemoveBox_<%=productCode%>"><%=removeText%></label>
        <%} %>

        <%if (canDowngrade)
            { %>
        <input type="checkbox" style="display: <%=upgradeStyle%>"
            id="downgradeTo_<%=productCode%>" name="downgradeTo_<%=productCode%>" value="<%=propDowngradeTo %>" ptype="<%=productType %>" takenonupsell="<%=wasTakenOnUpsell %>"
            data-from="<%=fromProductCode %>" data-changewith="<%=propChangeWith %>" data-action="downgrade"
            onchange="Update('<%=productCode%>',$('#ActionQuantity<%=count %>').val(), this);" />
        <label for="downgradeTo_<%=productCode%>" style="display: <%=upgradeStyle%>">
            <%=downgradeText%>
        </label>
        <% }
            if (canUpgrade)
            { %>
        <input type="checkbox" style="display: <%=downgradeStyle%>"
            id="upgradeTo_<%=productCode%>" name="upgradeTo_<%=productCode%>" value="<%=propUpgradeTo %>"
            data-from="<%=fromProductCode %>" data-changewith="<%=propChangeWith %>" data-action="upgrade"
            onchange="Update('<%=productCode%>',$('#ActionQuantity<%=count %>').val(), this);" />
        <label for="upgradeTo_<%=productCode%>" style="display: <%=downgradeStyle%>">
            <%=upgradeText%>
        </label>
        <% } %>
    </td>
</tr>
<% } %>
<% if (product.PropertyIndexer["HasOrderCode", false])
    {
        var label = product.PropertyIndexer["OrderCodeLabel"];
        var name = string.Format("OC_{0}_{1}", productCode, product.PropertyIndexer["OrderCodeLabelSuffix", "TEXT"]);
        var regexPattern = product.PropertyIndexer["OrderCodePattern"];
        regexPattern = string.IsNullOrWhiteSpace(regexPattern) ? "" : ("pattern=\"" + regexPattern + "\"");
        var placeholder = product.PropertyIndexer["OrderCodePlaceholder"];
        var maxlength = product.PropertyIndexer["OrderCodeMaxLength"];
        maxlength = string.IsNullOrWhiteSpace(maxlength) ? "" : ("maxlength=\"" + maxlength + "\"");
        var style = product.PropertyIndexer["OrderCodeStyle"];
        var regexMessage = product.PropertyIndexer["OrderCodeErrorMessage"];
        regexMessage = string.IsNullOrWhiteSpace(regexMessage) ? "Please match the requested format" : regexMessage;

%>
<tr class="table__support--prop">
    <td class="prop__hide--html">
        <%if (!string.IsNullOrWhiteSpace(label))
            { %>
        <label for="<%=name%>"><%=label%></label>
        <%} %>
    </td>
    <td colspan="4" class="prop__hide--label">
        <% var orderCodeValue = DtmContext.Order.Codes[name].Code;
            var orderCodes = ViewData["orderCodes"] as string;
            if (!string.IsNullOrWhiteSpace(orderCodes))
            {
                var values = HttpUtility.ParseQueryString(orderCodes);
                var value = values[name];
                if (!string.IsNullOrWhiteSpace(value))
                {
                    orderCodeValue = value;
                }
            }
            if (isConfirmationView)
            { %>
        <label><%=orderCodeValue%></label>
        <%}
            else
            { %>
        <input type="text" id="<%=name%>" name="<%=name%>" required class="c-brand--form__input o-box o-shadow fx--animate" placeholder="<%=placeholder %>" style="<%=style %>" <%=maxlength %> <%=regexPattern%> oninvalid="setCustomValidity('<%=regexMessage %>')" onkeyup="try{setCustomValidity('')}catch(e){}" value="<%=orderCodeValue%>" />
        <%} %>
    </td>
</tr>
<% } %>