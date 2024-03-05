<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>

<%

    var categoryName = "Tickets";
    var categoryVersionName = string.Format("{0}-{1}-{2}", categoryName, DtmContext.OfferCode, DtmContext.Version);
    var categoryOfferName = string.Format("{0}-{1}", categoryName, DtmContext.OfferCode);
    var categories = Model.Categories.Where(c => c.Code.Contains(categoryName)).ToList();
    var category = new Dtm.Framework.Base.Models.CategoryView();
    if(categories.Any(c=> string.Equals(categoryVersionName, c.Code, StringComparison.InvariantCultureIgnoreCase)))
    {
        category = categories.FirstOrDefault(c => string.Equals(categoryVersionName, c.Code, StringComparison.InvariantCultureIgnoreCase));
    }else if(categories.Any(c=> string.Equals(categoryOfferName, c.Code, StringComparison.InvariantCultureIgnoreCase)))
    {
        category = categories.FirstOrDefault(c => string.Equals(categoryOfferName, c.Code, StringComparison.InvariantCultureIgnoreCase));
    }else
    {
        category = Model.Categories.Where(c => string.Equals(categoryName, c.Code, StringComparison.InvariantCultureIgnoreCase)).FirstOrDefault();
    }

    var location = Model.Locations.AllSeminars.FirstOrDefault();

    if (category != null && location != null)
    {
        var products = Model.Products
            .Where(p => p.CategoryIndexer.Has(category.Code))
            .OrderBy(p => p.CategoryIndexer[category.Code]).ToList();
        var time = location.SeminarTimes.FirstOrDefault();
        if (products.Any() && time != null)
        {

            var firstProduct = products.First();
            var perkNamePropertyKey = "PerkName";
            var perkRankPropertyKey = "PerkRank";
            var ticketPerkNames = firstProduct.PropertyIndexer.ToDictionary().Keys.Where(p => p.Contains(perkNamePropertyKey)).ToList();
            var ticketPerks = new SortedList<int, Tuple<string, string>>();

            for (int i = 0; i < ticketPerkNames.Count(); i++)
            {
                int rank = i;

                var rankProp = ticketPerkNames[i].Replace(perkNamePropertyKey, perkRankPropertyKey);
                if (firstProduct.PropertyIndexer.Has(rankProp))
                {
                    int.TryParse(firstProduct.PropertyIndexer[rankProp], out rank);
                }

                ticketPerks.Add(rank, new Tuple<string, string>(ticketPerkNames[i].Replace(perkNamePropertyKey, string.Empty), firstProduct.PropertyIndexer[ticketPerkNames[i]]));
            }

            var showPerks = ViewData["ShowPerks"] as bool?;

%>
<section aria-label="Ticket packages & what's included" class="view view--tickets view--bg">
    <div id="ticket" class="view__anchor"></div>
    <div class="view__in">
        <div class="copy copy--title">
            <h2>Reserve Your Seat Now</h2>
            <a data-fancybox href="#seating" class="button" id="ticket-seating-chart">View Seating Chart</a>
            <%= Html.Partial("_AlertBanner") %>
        </div>

        <%= Html.ValidationSummary("The following errors have occured:") %>
        <div class="ticket">
            <div class="ticket__group">
                <div class="ticket__item ticket__item--info">
                    <div class="ticket__card ticket__card--info">
                        <div class="ticket__divider">
                            <div class="ticket__header">
                                <div class="ticket__title">
                                    <span>Ticket</span>
                                    <span>Packages</span>
                                    <span>& What's</span>
                                    <span>Included</span>
                                </div>
                            </div>
                        </div>
                        <%if (!showPerks.HasValue || showPerks.Value)
                            { %>
                        <ul>
                            <%
                                for (int i = 0; i < ticketPerks.Count; i++)
                                {
                            %>
                            <li><%= ticketPerks.Values[i].Item2 %></li>
                            <%
                                }

                            %>
                        </ul>
                        <%} %>
                    </div>
                </div>
                <div class="ticket__item ticket__item--options">
                    <div class="ticket__group">
                        <%
                            foreach (var item in products)
                            {
                                Html.RenderPartial("GetTicket", item, new ViewDataDictionary
                                   {
                                       {"TicketAttributes", ticketPerks},
                                       {"ShowImage", ViewData["ShowImage"] },
                                        { "ShowSeatingChart", ViewData["ShowSeatingChart"] }
                                   });
                            }
                        %>
                    </div>
                </div>
            </div>
            <% if (DtmContext.IsMobile)
                { %>
            <div class="ticket__directive">
                <div class="ticket__directive-image ticket__directive-close">
                    <span class="ticket__cross"></span>
                </div>
                <div class="ticket__directive-text">
                    <span>Swipe for each ticket package to see what's included</span>
                </div>
                <div class="ticket__directive-image ticket__directive-gesture">
                    <picture style="--arp: 138/150; max-width: 47px">
                            <img src="/images/gesture--scroll-x.svg" alt="">
                        </picture>
                </div>
            </div>
            <% } %>
            <div class="ticket__bg" data-src-img="/images/_bg-burst.svg"></div>
        </div>
    </div>
    <%
        if (!DtmContext.IsMobile)
        {
    %>
    <div class="view__bg" data-src-img="/images/_bg-crowd.jpg"></div>
    <%
        }
    %>
</section>
<%
    using (Html.BeginForm())
    {
%>
<div style="display: none">
    <input type="hidden" name="ActionCode0" value="<%=time.ProductCode %>" />
    <input type="hidden" name="ActionCode1" id="ActionCode1" value="" />
    <input type="hidden" name="ActionQuantity0" value="1" />
    <input type="hidden" name="ActionQuantity1" value="1" />
    <input type="hidden" name="OrderType" value="none" />
    <button type="submit" name="acceptOffer" id="AcceptOfferButton"></button>
</div>
<script type="text/javascript">
    function Checkout(code) {
        var actionCode = document.getElementById("ActionCode1");
        actionCode.setAttribute("value", code);

        document.getElementById("AcceptOfferButton").click();
    }
</script>
<%
            }
        }
    }
%>