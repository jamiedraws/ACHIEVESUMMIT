<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<System.Collections.Generic.Dictionary<int,Dtm.Framework.Base.Models.CampaignProductView>>" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce.Repositories" %>
<%@ Import Namespace="Dtm.Framework.Base.TokenEngines" %>
<%@ Import Namespace="Dtm.Framework.Base.Models" %>

<%
    var reOfferImageProperty = "ReOfferTableImage";
    var reOfferDescription = "ReOfferTableDescription";
    foreach (var item in Model)
    {
        var product = item.Value;
        var count = item.Key;
%>
<tr class="add<%=product.ProductCode %>">
    <td class="rebuttal__text c-brand__txt" data-sku="<%= product.ProductSku %>"> 
        
        <%
            if(product.PropertyIndexer.Has(reOfferImageProperty))
            {
        %>
                <img src="<%=product.PropertyIndexer[reOfferImageProperty] %>" />
        <%
            }
        %>

        <div class="rebuttal__group">
            <span class="rebuttal__sku"><%= product.ProductSku %></span>
            <div class="rebuttal__desc">
                <%= product.PropertyIndexer.Has(reOfferDescription) ? product.PropertyIndexer[reOfferDescription] : product.ProductName %>
            </div>
        </div>

    </td>
    <td class="rebuttal__actions c-brand--form__group">
        <i class="c-upsell__prefix">Qty:</i>
        <select name="Quantity<%=count %>" id="Quantity<%=count %>" style="color:#333;">
            <%
                for (int i = product.MinQuantity == 0 ? 1 : product.MinQuantity; i <= product.MaxQuantity; i++)
                {
            %><option value="<%=i %>"><%=i %></option>
            <%
                }
            %>
        </select>
    </td>
    <td class="rebuttal__add-tickets">
        <button type="button" data-code="<%=product.ProductCode %>" data-action="add" data-qty-ele="Quantity<%=count %>" class="btn btn--card" >Add Tickets</button>
    </td>
</tr>
<%} %>
