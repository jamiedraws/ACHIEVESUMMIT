<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/MainLayout.master" Inherits="System.Web.Mvc.ViewPage<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    var isRoot = string.Equals(DtmContext.OfferCode, SettingsManager.ContextSettings["Seminar.RootLinks.OfferCode", string.Empty], StringComparison.InvariantCultureIgnoreCase);
    var v = DtmContext.Version;
%>

<main aria-label="Unlock your potential for massive success" class="view view--hero view--bg">
    <div class="view__anchor" id="main"></div>
    <div class="view__in">
        <div class="group group--hero">

            <% if (!isRoot) { %>
            <div class="group__item group__item--seminar">
                <div class="seminar">
                    <h1>Unlock your potential <span><small>for</small> Massive Success</span></h1>
                    <%
                        var location = Model.Locations.AllSeminars.FirstOrDefault();
                        if (location != null)
                        {
                            %>
                            <div class="seminar__rect"><%= DtmContext.OfferVersion.Name %>, <%= location.State %> &bull; <%= location.SeminarFriendlyName %></div>
                            <%= Html.Partial("GetRootLink") %>
                            <%
                        }
                    %>
                    
                    <%= Html.Partial("CountDown") %>

                    <nav aria-label="Buy tickets or learn more">
                        <a href="#ticket" id="hero-ticket" class="button">Buy Tickets</a> 
                        <a href="#seminar" id="hero-learn" class="button button--outline">Learn More</a>
                    </nav>
                    <div class="seminar__desc">Tickets starting at $19</div>
                </div>
                <%= Html.Partial("_Performers") %>
            </div>
            <% } else { %>
            <div class="group__item group__item--seminar">
                <div class="seminar">
                    <h1>Unlock your potential <span><small>for</small> Massive Success</span></h1>
                    <div class="seminar__rect seminar__rect--alternate">Upcoming Events</div>
                    <%= Html.Partial("SeminarRootLinks") %>
                </div>
            </div>
            <% } %>
            <div class="group__item group__item--hero">
                <picture style="--arp: 548/717; --arp-max: 548px">
                    <img src="/images/hero/robert-kiyosaki-no-ribbon.png" alt="Robert Kiyosaki's book, Rich Dad Poor Dad has sold more than 3 million copies">
                </picture>
                <img class="view__ribbon" src="/images/blue-ribbon.svg" alt="Robert Kiyosaki & Friends Live In Person">
            </div>
        </div>
    </div>
    <img class="view__bg" src="/images/_bg-burst.svg" alt="">
    <% if (!DtmContext.IsMobile) { %>
    <img class="view__bg view__bg--hero" src="/images/_bg-crowd.jpg" alt="">
    <% } %>
</main>

<% if (isRoot) {
    Html.RenderPartial("_AlertBanner");
} %>

<section aria-label="Learn top strategies for success" class="view">
    <div class="view__anchor" id="seminar"></div>
    <div class="view__in">
        <div class="group group--seminar">
            <div class="group__item">
                <% 
                    var videoId = SettingsManager.ContextSettings["FrameworkJS/CSS.Eflex.Play.Source", string.Empty];

                    if (!String.IsNullOrWhiteSpace(videoId)) {
                        var videoSrc = String.Format("https://player.vimeo.com/video/{0}?title=0&byline=0&portrait=0", videoId);
                %>
                <div class="arp arp--fill" style="--arp:524/296;--arp-max:524px" data-src-iframe="<%= videoSrc %>" data-attr='{ "title" : "Welcome to the Wealth & Achievement Summit", "width" : "524", "height" : "296", "allowfullscreen" : "true" }'>
                </div>
                <% } %>
            </div>
            <div class="group__item">
                <div class="copy copy--list">
                    <h2>Learn top Strategies for Success</h2>
                    <ul>
                        <li>Critical Seminar for Business Owners, Investors and Employees</li>
                        <li>Must-Attend Seminar for any Entrepreneur or Investor</li>
                        <li>Get what you need NOW to Save Your Business and your Assets</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>
    
</asp:Content>