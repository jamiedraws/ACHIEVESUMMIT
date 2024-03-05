<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<section aria-label="Speakers" class="view view--contrast">
    <div class="view__anchor" id="speakers"></div>
    <div class="view__in">
        <div class="copy copy--title">
            <h2>Your Mentors <strong>Live & In Person</strong></h2>
        </div>
    </div>
    <% 
        var rk = "/images/robert-kiyosaki.jpg";
        var ja = "/images/jay-abraham.jpg";
        var gs = "/images/glenn-stearns.jpg";
        var bf = "/images/brian-forte.jpg";

        if (DtmContext.IsMobile)
        {
            rk = "/images/robert-kiyosaki@1x.jpg";
            ja = "/images/jay-abraham@1x.jpg";
            gs = "/images/glenn-stearns@1x.jpg";
            bf = "/images/brian-forte@1x.jpg";
        }
    %>
    <nav aria-label="Speakers profile pages" class="image-card">
        <a id="speaker-robert-kiyosaki" href="Robert-Kiyosaki<%= DtmContext.ApplicationExtension %>">
            <picture data-src-img="<%= rk %>" data-attr='{ "alt": "Robert Kiyosaki" }' class="arp arp--fill" style="--arp: 374/419; max-width: 374px">
                <noscript>
                    <img src="<%= rk %>" alt="Robert Kiyosaki">
                </noscript>
            </picture>
            <div class="image-card__title">
                <span>Robert Kiyosaki</span>
                <small>World's #1 Finance Expert</small>
                <span class="image-card__plus"></span>
            </div>
        </a>
        <a id="speaker-jay-abraham" href="Jay-Abraham<%= DtmContext.ApplicationExtension %>">
            <picture data-src-img="<%= ja %>" data-attr='{"alt": "Jay Abraham"}' class="arp arp--fill" style="--arp: 374/419; max-width: 374px">
                <noscript>
                    <img src="<%= ja %>" alt="Jay Abraham">
                </noscript>
            </picture>
            <div class="image-card__title">
                <span>Jay Abraham</span>
                <small>World's #1 Marketing Expert</small>
                <span class="image-card__plus"></span>
            </div>
        </a>
        <a id="speaker-brina-forte" href="Brian-Forte<%= DtmContext.ApplicationExtension %>">
            <picture data-src-img="<%= bf %>" data-attr='{ "alt": "Brian Forte"}' class="arp arp--fill" style="--arp: 374/419; max-width: 374px" data-arp-max="374px">
                <noscript>
                    <img src="<%= bf %>" alt="Brian Forte">
                </noscript>
            </picture>
            <div class="image-card__title">
                <span>Brian J. Forte</span>
                <small>America's #1 Business Trainer</small>
                <span class="image-card__plus"></span>
            </div>
        </a>
    </nav>
</section>