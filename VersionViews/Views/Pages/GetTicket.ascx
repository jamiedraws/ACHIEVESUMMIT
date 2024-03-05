<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.CampaignProductView>" %>
<% 
    var ticketAttributes = ViewData["TicketAttributes"] as SortedList<int, Tuple<string, string>> ?? new SortedList<int, Tuple<string, string>>();
    var disabledProp = Model.PropertyIndexer.Has("SoldOut") ? Model.PropertyIndexer["SoldOut"] : "false";
    var bogoProp = Model.PropertyIndexer.Has("IsBogo") ? Model.PropertyIndexer["IsBogo"] : "false";
    var disabledClass = "ticket__disable";
    var showImage = ViewData["ShowImage"] as bool?;
    var showSeatingChartViewData = ViewData["ShowSeatingChart"] as bool?;
    var isDisabled = false;

    bool isBogo = false;

    bool showSeatingChart = showSeatingChartViewData.HasValue ? showSeatingChartViewData.Value : false;
    bool.TryParse(bogoProp, out isBogo);
    bool.TryParse(disabledProp, out isDisabled);

    var buttonHtmlTop = string.Empty;
    var buttonHtmlBottom = string.Empty;
    if (isDisabled)
    {
        buttonHtmlTop = string.Format("<a href=\"#\" id=\"ticket-top-{0}\" disabled class=\"button button--oos\">Sold Out!</a>", Model.ProductCode);
        buttonHtmlBottom = string.Format("<a href=\"#\" id=\"ticket-bottom-{0}\" disabled class=\"button button--oos\">Sold Out!</a>", Model.ProductCode);
    }
    else
    {
        buttonHtmlTop = string.Format("<a id=\"ticket-top-{0}\" href=\"javascript:Checkout('{0}')\" class=\"button\">Buy Tickets</a>", Model.ProductCode);
        buttonHtmlBottom = string.Format("<a id=\"ticket-bottom-{0}\" href=\"javascript:Checkout('{0}')\" class=\"button\">Buy Tickets</a>", Model.ProductCode);
    }

%>
<div id="<%= Model.ProductSku %>" class="ticket__card ticket__card--<%=Model.ProductSku.ToLower() %> <%=isDisabled? disabledClass : string.Empty %> ">
    <div class="ticket__header">
        <h3><%=Model.ProductSku %></h3>
        <p><%=isBogo ? "Two Tickets" : "Single Ticket" %></p>
        <div class="ticket__price">
            <sup>$</sup><%=Model.Price.ToString("##") %>
        </div>
        <%=buttonHtmlTop %>
    </div>
    <ul>
        <%
    if (showSeatingChart)
            {
                %>
            <li class="ticket__seating-chart">
                <a href="#seating" data-fancybox>
                    <img src="/images/icon-seating-chart.png" alt="View seating chart">
                </a>
            </li>
                <%
            }
    for (int i = 0; i < ticketAttributes.Count; i++)
    {
        var property = ticketAttributes.Values[i].Item1;
        var value = Model.PropertyIndexer.Has(property) ? Model.PropertyIndexer[property] : "false";
        var bValue = false;
        if (bool.TryParse(value, out bValue))
        {
        %>
        <li class="<%=bValue ? string.Empty : disabledClass %>">
            <%
                if (!showImage.HasValue || showImage.Value)
                {
            %>
            <picture style="--arp: 45/45; max-width: 45px">
                            <img src="/images/icon-thumb-up.svg" alt="">
                        </picture>
            <%
                }
                else
                {
            %>
            <%=ticketAttributes.Values[i].Item2 %>
            <%
                }
            %>
        </li>
        <%
            }
            else
            {
        %>
        <li><%=value %></li>
        <%
                }
            }
        %>
    </ul>
    <%=buttonHtmlBottom %>
    <% if (isBogo)
        { %>
    <div class="ticket__callout">
        Buy One, Get One FREE!
    </div>
    <% } %>
</div>
