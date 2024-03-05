<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%
    var originalProductCodes = ((ViewData["NewOriginalItems"] ?? ViewData["OriginalItems"]) as string ?? string.Empty).Split(',');
    var cartProductCodes = ((ViewData["NewCartItems"] ?? ViewData["CartItems"]) as string ?? string.Empty).Split(',');
    var upgradedFrom = ((ViewData["UpgradedFrom"]) as string ?? string.Empty).Split(',');
    var downgradedFrom = ((ViewData["DowgradedFrom"]) as string ?? string.Empty).Split(',');
    var currentHiddenItems = DtmContext.Order.ContextOrderItems.Where(oi=> oi.CachedProductInfo.ProductTypeId == 0).ToList();
    var currentOrderItems = DtmContext.Order.VisibleOrderItems.ToList();
    var ShowFutureChangesFooter = SettingsManager.ContextSettings["SummaryReviewTable.DisplayMonthlyExtendedPriceFooter", false];
    var allItems = currentOrderItems;
    var showSavingsBanner = SettingsManager.ContextSettings["SummaryReviewTable.ShowSavingsBanner", false];
    var colSet = false;
    var enabledKeys =  SettingsManager.ContextSettings["SummaryReviewTable.EnabledKeys", "orderCodes"];

    //Table Columns to Show
    var ShowItemColumn = SettingsManager.ContextSettings["SummaryReviewTable.ShowItemColumn", true];
    var ShowDescriptionColumn = SettingsManager.ContextSettings["SummaryReviewTable.ShowDescriptionColumn", true];
    var ShowQuantityColumn = SettingsManager.ContextSettings["SummaryReviewTable.ShowQuantityColumn", true];
    var ShowSubtotalColumn = SettingsManager.ContextSettings["SummaryReviewTable.ShowSubtotalColumn", true];
    var ShowShippingColumn = SettingsManager.ContextSettings["SummaryReviewTable.ShowShippingColumn", false];

    //Table Label Variables
    var taxRowLabel = SettingsManager.ContextSettings["SummaryReviewTable.TaxRowLabel", "Tax"];
    var orderTotalRowLabel = SettingsManager.ContextSettings["SummaryReviewTable.OrderTotalRowLabel", "Order&nbsp;Total"];
    var subTotalRowLabel = SettingsManager.ContextSettings["SummaryReviewTable.SubTotalRowLabel", "Sub&nbsp;Total"];
    var quantityColumnLabel = SettingsManager.ContextSettings["SummaryReviewTable.QuantityColumnLabel", "Quantity"];
    var itemColumnLabel = SettingsManager.ContextSettings["SummaryReviewTable.ItemColumnLabel", "Item"];
    var descriptionColumnLabel = SettingsManager.ContextSettings["SummaryReviewTable.DescriptionColumnLabel", "Description"];
    var subTotalColumnLabel = SettingsManager.ContextSettings["SummaryReviewTable.SubtotalColumnLabel", "Sub&nbsp;Total"];
    var shippingColumnLabel = SettingsManager.ContextSettings["SummaryReviewTable.ShippingColumnLabel", "S&H"];
    var showSaleTaxLink = SettingsManager.ContextSettings["OrderFormReview.ShowSalesTax", false];
    var surchXProductCode = SettingsManager.ContextSettings["SurchX.ProductCode", "SURCHX"];

    //Set Table Column Number
    var numberOfColumns = 0;
    if (ShowItemColumn)
        numberOfColumns++;
    if (ShowDescriptionColumn)
        numberOfColumns++;
    if (ShowQuantityColumn)
        numberOfColumns++;
    if (ShowSubtotalColumn)
        numberOfColumns++;
    if (ShowShippingColumn)
        numberOfColumns++;

    if (SettingsManager.ContextSettings["SummaryReviewTable.KeepZeroItems", true])
    {
        var newItems = cartProductCodes
             .Where(originalProductCode => DtmContext.Order.VisibleOrderItems.All(oi =>
             {
                 var currentProductCode = originalProductCode;

                 var parentProduct = DtmContext.CampaignProducts.FirstOrDefault(cp => cp.RelatedProducts
                 .Any(rp =>
                 {
                     var isLineItem = rp.IsLineItem;
                     if(isLineItem)
                     {
                         var campaignProduct = DtmContext.CampaignProducts.FirstOrDefault(p => p.CampaignProductId == rp.CampaignProductId);

                         if(campaignProduct != null && campaignProduct.ProductCode.Equals(originalProductCode, StringComparison.InvariantCultureIgnoreCase))
                         {
                             return true;
                         }
                     }


                     return false;

                 }));
                 if (parentProduct != null) //if is line item, use parent product code
                     currentProductCode = parentProduct.ProductCode;

                 var oiProductCode = oi.CachedProductInfo.ProductCode;
                 var downgradeTo = oi.CachedProductInfo.PropertyIndexer["DowngradeTo"] ?? string.Empty;
                 var upgradeTo = oi.CachedProductInfo.PropertyIndexer["UpgradeTo"] ?? string.Empty;
                 //variable set to show/hide a product and its children from the review table.
                 var isHidden = oi.CachedProductInfo.PropertyIndexer["HideProduct"] ?? string.Empty;

                 var oiParentProduct = DtmContext.CampaignProducts.FirstOrDefault(cp => cp.RelatedProducts
                 .Any(rp =>
                 {
                     var isLineItem = rp.IsLineItem;
                     if(isLineItem)
                     {
                         var campaignProduct = DtmContext.CampaignProducts.FirstOrDefault(p => p.CampaignProductId == rp.CampaignProductId);

                         if(campaignProduct != null && campaignProduct.ProductCode.Equals(oi.CachedProductInfo.ProductCode, StringComparison.InvariantCultureIgnoreCase))
                         {
                             return true;
                         }
                     }


                     return false;

                 }));

                 if (oiParentProduct != null) //if OI is line item, then use parent product code and properties
                 {
                     oiProductCode = oiParentProduct.ProductCode;
                     downgradeTo = oiParentProduct.PropertyIndexer["DowngradeTo"] ?? string.Empty;
                     upgradeTo = oiParentProduct.PropertyIndexer["UpgradeTo"] ?? string.Empty;
                     //variable set to show/hide a product and its children from the review table.
                     isHidden = oiParentProduct.PropertyIndexer["HideProduct"] ?? string.Empty;
                 }

                 // compare parent vs parent if both are line items
                 // check if original product exists in current order items
                 return !oiProductCode.Equals(currentProductCode, StringComparison.InvariantCultureIgnoreCase)
                     // check that downgrade to does not exist in current order items
                     && !downgradeTo.Equals(currentProductCode, StringComparison.InvariantCultureIgnoreCase)
                     // ch eck that upgrade to does not exist in current order items
                     && !upgradeTo.Equals(currentProductCode, StringComparison.InvariantCultureIgnoreCase);
             }))
             .ToList();

        if (newItems.Any())
        {
            newItems.ForEach(newOrderItem =>
            {
                var campaignProduct = DtmContext.CampaignProducts.FirstOrDefault(cp => cp.ProductCode == newOrderItem);
                if (campaignProduct != null)
                {
                    allItems.Add(new OrderItem
                    {
                        CampaignProductId = campaignProduct.CampaignProductId,
                        CachedProductInfo = campaignProduct,
                        IsTaxable = campaignProduct.IsTaxable,
                        Description = campaignProduct.ProductName,
                        ProductSku = campaignProduct.ProductSku,
                        AdditionalItemInformation = campaignProduct.DisplayText,
                        Price = campaignProduct.Price,
                        Shipping = campaignProduct.Shipping,
                        Quantity = 0,
                        ReportPrice = campaignProduct.ReportPrice,
                        ExtendedPrice = campaignProduct.ExtendedPrice,
                        TaxExtendedPrice = campaignProduct.TaxExtendedPrice,
                    });
                }
            });
        }
        allItems = allItems.ToLineItems();
    }

    var removedItems = originalProductCodes
    .Where(op => !allItems.Any(i =>
    {
        var currentProductCode = i.CachedProductInfo.ProductCode;
        var parentProduct = DtmContext.CampaignProducts.FirstOrDefault(cp => cp.RelatedProducts
                 .Any(rp =>
                 {
                     var isLineItem = rp.IsLineItem;
                     if(isLineItem)
                     {
                         var campaignProduct = DtmContext.CampaignProducts.FirstOrDefault(p => p.CampaignProductId == rp.CampaignProductId);

                         if(campaignProduct != null && campaignProduct.ProductCode.Equals(currentProductCode, StringComparison.InvariantCultureIgnoreCase))
                         {
                             return true;
                         }
                     }


                     return false;

                 }));
        if (parentProduct != null) //if is line item, use parent product code
            currentProductCode = parentProduct.ProductCode;
        return currentProductCode.Equals(op, StringComparison.InvariantCultureIgnoreCase);
    })
    )
    .ToList();
%>

<div id="orderItemsPlaceholder">
    <%if (showSavingsBanner)
        { %>
    <% Html.RenderPartial("SavingsBanner");
        }
    %>
    <table class="orderItemsTable c-brand--table c-brand--table--cart c-brand--form u-vw--100 u-mar--vert" cellpadding="3" cellspacing="0" border="0">
        <thead>
            <tr>
                <%if (ShowItemColumn)
                    {%>
                <th><span><%=itemColumnLabel%></span></th>
                <%}%>

                <%if (ShowDescriptionColumn)
                    {%>
                <th><span><%=descriptionColumnLabel%></span></th>
                <%}%>

                <%if (ShowQuantityColumn)
                    {%>
                <th align="right"><span><%=quantityColumnLabel%></span></th>
                <%}%>

                <%if (ShowSubtotalColumn)
                    {%>
                <th align="right"><span><%=subTotalColumnLabel%></span></th>
                <%}%>

                <%if (ShowShippingColumn)
                    {%>
                <th align="right"><span><%=shippingColumnLabel%></span></th>
                <%}%>
            </tr>
        </thead>
        <tbody class="orderItemsTableBody">
            <%
                for (int i = 0; i < allItems.Count; i++)
                {
                    var item = allItems.ElementAt(i);
                    Html.RenderPartial("SummaryReviewTableRow", new ViewDataDictionary
                    {
                        { "OrderItem", item },
                        { "Index", i },
                        { "ShowItem", ShowItemColumn },
                        { "ShowDescription", ShowDescriptionColumn },
                        { "ShowQuantity", ShowQuantityColumn },
                        { "ShowSubtotal", ShowSubtotalColumn },
                        { "ShowShipping", ShowShippingColumn }
                    });
                } 
            %>
        </tbody>
        <tfoot>
            <%if (Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.SubtotalRow", true])
                {%>
            <tr>
                <td colspan="<%=numberOfColumns - 2%>" rowspan="4">&nbsp;</td>
                <td><%=subTotalRowLabel%></td>
                <td align="right">
                    <div id="SubTotal"><%= DtmContext.Order.SubTotal.ToString("C")%></div>
                </td>
            </tr>
            <%
                    colSet = true;
                }%>
            <%if (SettingsManager.ContextSettings["SummaryReviewTable.ShowShippingFooter", true])
                {%>
            <tr>
                <%if (!colSet)
                    { %><td colspan="<%=numberOfColumns - 2%>" rowspan="4">&nbsp;</td>
                <%} %>
                <td><%= SettingsManager.ContextSettings["SummaryReviewTable.ShippingColumnLabel"]%></td>
                <td align="right">
                    <div id="ShippingCost"><%= DtmContext.Order.ShippingCost.ToString("C")%></div>
                </td>
            </tr>
            <%
                    colSet = true;
                } %>
            <%if (Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.TaxRow", true])
                {%>
            <tr>
                <%if (!colSet)
                    { %><td colspan="<%=numberOfColumns - 2%>" rowspan="4">&nbsp;</td>
                <%} %>
                <td><%=taxRowLabel%></td>
                <td align="right">
                    <div id="TotalTax"><%= DtmContext.Order.TotalTax.ToString("C")%></div>
                </td>
            </tr>
            <%
                    colSet = true;
                } 
                if (currentHiddenItems.Any(oi => oi.CachedProductInfo.ProductCode == surchXProductCode))
                {
                    var surchxProduct = currentHiddenItems.FirstOrDefault(oi => oi.CachedProductInfo.ProductCode == surchXProductCode);
                %>
            <tr>
                <%if (!colSet)
                    { %><td colspan="<%=numberOfColumns - 2%>" rowspan="4">&nbsp;</td>
                <%} %>
                <td><%= surchxProduct.Description%></td>
                <td align="right">
                    <div id="surchXFee"><%= surchxProduct.Price.ToString("C")%></div>
                </td>
            </tr>
            <%
                    colSet = true;
                } %>
            <%if (Dtm.Framework.ClientSites.SettingsManager.ContextSettings["SummaryReviewTable.OrderTotalRow", true])
                {%>
            <tr>
                <%if (!colSet)
                    { %><td colspan="<%=numberOfColumns - 2%>" rowspan="4">&nbsp;</td>
                <%} %>
                <td><%=orderTotalRowLabel%></td>
                <td align="right">
                    <div id="OrderTotal"><%= DtmContext.Order.OrderTotal.ToString("C")%></div>
                </td>
            </tr>
            <%
                    colSet = true;
                }%>
                
                        <% if (showSaleTaxLink) { %>
            <tr>
                <td colspan="5">
                    <a href="<%= LabelsManager.Labels["ReviewTableSaleTaxLink"] %>" data-fancybox-url="<%= LabelsManager.Labels["ReviewTableSaleTaxLink"] %>" title="<%= LabelsManager.Labels["ReviewTableSaleTaxTitle"] %>"><%= LabelsManager.Labels["ReviewTableSaleTaxLinkText"] %></a>
                </td>
            </tr>
            <% } %> 
                
        </tfoot>
    </table>

    <%if (ShowFutureChangesFooter)
        {%>            <%
                           var monthlyPayments = new Dictionary<int, Tuple<decimal, decimal>>();
                           for (int i = 0; i < allItems.Count; i++)
                           {
                               var item = allItems[i];
                               var product = item.CachedProductInfo;
                               var numPayments = product.NumberOfPayments;

                               if (numPayments > 1)
                               {
                                   if (monthlyPayments.ContainsKey(numPayments))
                                   {
                                       monthlyPayments[numPayments] = Tuple.Create<decimal, decimal>((product.ExtendedPrice ?? 0) * item.Quantity, product.Price);
                                   }
                                   else
                                   {
                                       var monthlyPaymetTotal = (decimal)((product.ExtendedPrice ?? 0) * item.Quantity);
                                       monthlyPayments.Add(numPayments, new Tuple<decimal, decimal>(monthlyPaymetTotal, product.Price));
                                   }
                               }
                           }

                           var monthlyInstallments = new List<decimal>();

                           foreach (var payment in monthlyPayments)
                           {
                               var numberOfPayments = payment.Key - (payment.Value.Item2 > 0 ? 1 : 0);
                               var monthlyTotal = payment.Value.Item1 / numberOfPayments;

                               for (int i = 0; i < numberOfPayments; i++)
                               {
                                   monthlyInstallments.Add(monthlyTotal);
                               }
                           } %>
    <%if (monthlyInstallments.Any())
        {%>
    <table class="orderItemsTable" cellpadding="3" cellspacing="0" border="0">
        <thead>
            <tr>
                <th colspan="2"><span>Future Charges</span></th>
            </tr>
        </thead>
        <tbody>
            <%
                for (int i = 0; i <= monthlyInstallments.Count - 1; i++)
                {
                    switch (i)
                    {
                        case 0:
            %><tr>
                <td>2nd Payment in 30 days</td>
                <td align="right"><%=string.Format("${0:#.00}", Convert.ToDecimal(monthlyInstallments[i]))%></td>
            </tr>
            <%
                    break;
                case 1:
            %><tr>
                <td>3rd Payment in 60 days</td>
                <td align="right"><%=string.Format("${0:#.00}", Convert.ToDecimal(monthlyInstallments[i]))%></td>
            </tr>
            <%
                    break;
                default:
            %><tr>
                <td><%=i + 2%>th Payment in <%=i + 30%> days</td>
                <td align="right"><%=string.Format("${0:#.00}", Convert.ToDecimal(monthlyInstallments[i]))%></td>
            </tr>
            <%
                        break;
                    }
                }
            %>
        </tbody>
    </table>
    <%}
        }%>

    <%
        string additionalItems = string.Empty;
        string codeLabel = "ActionCode";
        string qtyLabel = "ActionQuantity";
        for (int i = 0, count = allItems.Count; i < removedItems.Count; i++, count++)
        {
            var item = removedItems.ElementAt(i);

            additionalItems += Html.Hidden(codeLabel + count, item);
            additionalItems += Html.Hidden(qtyLabel + count, 0);
        } 

        for (int i = 0, count = allItems.Count + removedItems.Count; i < currentHiddenItems.Count; i++, count++)
        {
            var item = currentHiddenItems.ElementAt(i);

            additionalItems += Html.Hidden(codeLabel + count, item.CachedProductInfo.ProductCode);
            additionalItems += Html.Hidden(qtyLabel + count, item.Quantity);
        }
    %>
    <%=additionalItems %>
</div>

<%if (ViewData["NewCartItems"] != null || ViewData["NewOriginalItems"] != null || ViewData["UpgradedFrom"] != null || ViewData["DowngradedFrom"] != null)
    { %>
<script>
<%if (ViewData["NewCartItems"] != null)
    { %>
    __cartItems = "<%=ViewData["NewCartItems"]%>".split(',');
    <%} %>

<%if (ViewData["NewOriginalItems"] != null)
    { %>
    __ogItems = "<%=ViewData["NewOriginalItems"]%>".split(',');
    <%} %>  

     <%if (ViewData["UpgradedFrom"] != null)
    { %>
    __upFrom = "<%=ViewData["UpgradedFrom"]%>".split(',');
    <%} %> 
    <%if (ViewData["DowngradedFrom"] != null)
    { %>
    __downFrom = "<%=ViewData["DowngradedFrom"]%>".split(',');
    <%} %> 
</script>
<%} %>
<input type="hidden" name="RemoveExistingItems" value="true" />