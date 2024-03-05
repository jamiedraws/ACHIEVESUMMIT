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

<section aria-label="How to address COVID-19 in your business now" class="view">
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
                    <h2>How to address COVID-19 in your business now</h2>
                    <ul>
                        <li>Critical Seminar for Business Owners, Investors and Employees</li>
                        <li>How to Succeed in Times of Crisis</li>
                        <li>How to Survive the Business Apocalypse</li>
                        <li>Must-Attend Seminar for any Entrepreneur or Investor</li>
                        <li>Get what you need NOW to Save Your Business and your Assets</li>
                        <li>How to Turn Chaos into Opportunity</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="group group--logos">
        <picture data-src-img="/images/logos/msnbc.png" data-attr='{ "alt": "MSNBC" }' style="--arp:103/68;--arp-max:103px">
            <noscript>
                <img src="/images/logos/msnbc.png" alt="MSNBC">
            </noscript>
        </picture>
        <picture data-src-img="/images/logos/cnn.png" data-attr='{ "alt": "CNN" }' style="--arp:135/63;--arp-max:135px">
            <noscript>
                <img src="/images/logos/cnn.png" alt="CNN">
            </noscript>
        </picture>
        <picture data-src-img="/images/logos/oprah.png" data-attr='{ "alt" : "Oprah" }' style="--arp:128/75;--arp-max:128px">
            <noscript>
                <img src="/images/logos/oprah.png" alt="Oprah">
            </noscript>
        </picture>
        <picture data-src-img="/images/logos/larry-king-live.png" data-attr='{ "alt" : "Larry King Live" }' style="--arp:119/75;--arp-max:119px">
            <noscript>
                <img src="/images/logos/larry-king-live.png" alt="Larry King Live">
            </noscript>
        </picture>
        <picture data-src-img="/images/logos/time-magazine.png" data-attr='{ "alt" : "Time Magazine" }' style="--arp:155/51;--arp-max:155px">
            <noscript>
                <img src="/images/logos/time-magazine.png" alt="Time Magazine">
            </noscript>
        </picture>
        <picture data-src-img="/images/logos/inc-500.png" data-attr='{ "alt" : "Inc. 500" }' style="--arp:90/63;--arp-max:90px">
            <noscript>
                <img src="/images/logos/inc-500.png" alt="Inc. 500">
            </noscript>
        </picture>
        <picture data-src-img="/images/logos/entreprenuer-magazine.png" data-attr='{ "alt" : "Entreprenuer Magazine" }' style="--arp:261/58;--arp-max:261px">
            <noscript>
                <img src="/images/logos/entreprenuer-magazine.png" alt="Entreprenuer Magazine">
            </noscript>
        </picture>
    </div>
</section>
    
</asp:Content>