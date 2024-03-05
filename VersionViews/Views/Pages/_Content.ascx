<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var seminarName = SettingsManager.ContextSettings["Label.ProductName"];

    var isRoot = string.Equals(DtmContext.OfferCode, SettingsManager.ContextSettings["Seminar.RootLinks.OfferCode", string.Empty], StringComparison.InvariantCultureIgnoreCase);

    var isIndex = DtmContext.PageCode == "Index";
    var logoLink = "index" + DtmContext.ApplicationExtension;

    var ctaLink = "#ticket";
    var ctaText = "Buy Tickets";

    if (isIndex)
    {
        logoLink = "#main";

        if (isRoot)
        {
            ctaLink = "#main";
        }
    }

    if (isRoot)
    {
        ctaText = "Upcoming Events";
    }

    if (isRoot && !isIndex)
    {
        ctaLink = "index" + DtmContext.ApplicationExtension;
    }

    var id = (int?)ViewData["id"] ?? 0;
%>

<% if (id == 1) { %>
    <header class="view view--header">
        <div class="view__in">
            <nav aria-label="Website pages links" class="nav">
                <% if (DtmContext.IsMobile) { %>
                <a href="<%= logoLink %>" id="header-logo" class="nav__logo">
                    <img src="/images/logos/wealth-achievement-summit-compact.svg" alt="<%= seminarName %>">
                </a>
                <% } %>
                <input class="nav__toggle" type="checkbox" id="nav__toggle">
                <label class="nav__label" for="nav__toggle" aria-label="Toggle Menu"><span></span></label>
                <div class="nav__underlay" for="nav__toggle" role="presentation" aria-label="Hide Menu"></div>
                <div class="nav__pane">
                    <div class="nav__group">
                        <div class="nav__menu nav__menu--scroll">
                            <a href="<%= logoLink %>" id="header-logo-nav" class="nav__title">
                                <% if (!DtmContext.IsMobile && isIndex) { %>
                                <picture class="arp arp--logo" style="--arp: 220/214; max-width: 220px">
                                    <img src="/images/logos/wealth-achievement-summit.svg" alt="<%= seminarName %>">
                                </picture>
                                <% } %>
                                <% if (!isIndex) { %>
                                    <picture class="arp arp--logo-compact" style="--arp:247/70;max-width:247px">
                                            <img src="/images/logos/wealth-achievement-summit-compact.svg" alt="<%= seminarName %>">
                                    </picture>
                                <% } else { %>
                                    <picture class="arp arp--logo-compact" style="--arp:247/70;max-width:247px" data-src-img="/images/logos/wealth-achievement-summit-compact.svg" data-attr='{ "alt" : "<%= seminarName %>" }'>
                                        <noscript>
                                            <img src="/images/logos/wealth-achievement-summit-compact.svg" alt="<%= seminarName %>">
                                        </noscript>
                                    </picture>
                                <% } %>
                            </a>
                            <div class="list nav__list">
                                <a href="#about" id="header-about">
                                    <span>About the event</span>
                                </a>
                                <a href="#speakers" id="header-speakers">
                                    <span>The speaker list</span>
                                </a>
                                <% if (!isRoot)
                                { %>
                                <a href="#event" id="header-event">
                                    <span>Event details</span>
                                </a>
                                <% } %>
                                <a href="#reviews" id="header-reviews">
                                    <span>Event reviews</span>
                                </a>
                                <a href="#faq" id="header-faq">
                                    <span>FAQ</span>
                                </a>
                                <% if (!isIndex || !isRoot) { %>
                                <a href="<%= ctaLink %>" id="header-cta" class="button">
                                    <span><%= ctaText %></span>
                                </a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
    </header>    
<% } %>

<% if (id == 3) { %>
    <section aria-label="Media & attendee review" class="view view--lighter view--bg">
        <div id="reviews" class="view__anchor"></div>
        <div class="view__in">
            <div class="copy copy--title">
                <h2>Media & Attendee Review</h2>
            </div>
            <div class="cards">
                <blockquote>
                    <picture data-src-img="/images/logos/time-magazine-color.png" data-attr='{ "alt": "Time Magazine" }' style="--arp: 100/30; max-width: 100px">
                        <noscript>
                            <img src="/images/logos/time-magazine-color.png" alt="Time Magazine">
                        </noscript>
                    </picture>
                    <span>"Hot road show delivers... the motivational Dream Team." <strong>- TIME magazine</strong></span>
                </blockquote>
                <blockquote>
                    <picture data-src-img="/images/logos/people-magazine.png" data-attr='{ "alt": "People Magazine" }' style="--arp: 100/41; max-width: 100px">
                        <noscript>
                            <img src="/images/logos/people-magazine.png" alt="People Magazine">
                        </noscript>
                    </picture>
                    <span>"His star speakers work magic... It's a first-class organization." <strong>- PEOPLE magazine</strong></span>
                </blockquote>
                <blockquote>
                    <picture data-src-img="/images/logos/washington-post.png" data-attr='{ "alt": "Washington Post" }' style="--arp: 203/29; max-width: 203px">
                        <noscript>
                            <img src="/images/logos/washington-post.png" alt="Washington Post">
                        </noscript>
                    </picture>
                    <span>"The Super Bowl of Success." <strong>- The Washington Post</strong></span>
                </blockquote>
                <blockquote>
                    <picture data-src-img="/images/logos/wsj.png" data-attr='{ "alt" : "Wall Street Journal" }' style="--arp: 66/42; max-width: 66px">
                        <noscript>
                            <img src="/images/logos/wsj.png" alt="Wall Street Journal">
                        </noscript>
                    </picture>
                    <span>"A barnstorming feel-good tour de force." <strong>- The Wall Street Journal</strong></span>
                </blockquote>
                <blockquote>
                    <span>"Personally I have grown by attending the program and have a new outlook on many things in my life. <strong>- Jason Zigmont, Founder, VolunteerFD.org</strong></span>
                </blockquote>
                <blockquote>
                    <span>"Each speaker had great information! You have to go to this event! My negotiation skills were dramatically impacted by this event!" <strong>- Karen Hay</strong></span>
                </blockquote>
                <blockquote>
                    <span>"I wish I would have brought all my friends!  The business tips have inspired me for the future!"  <strong>- Gerald Cater</strong></span>
                </blockquote>
                <blockquote>
                    <span>"It's great for anyone in any profession! It gives you a different perspective!"  <strong>- Kim Oliveira</strong></span>
                </blockquote>
                <blockquote>
                    <span>"This seminar is a great idea! I will now make wiser investing choices and share the wisdom I learned!" <strong>- Eunice Devers , Teacher</strong></span>
                </blockquote>
                <blockquote>
                    <span>"Totally awesome and captivating! You can't afford not to go! I know that I can and will achieve my goals!" <strong>- Victoria Rosado</strong></span>
                </blockquote>
            </div>
        </div>
        <div class="view__bg" data-src-img="/images/icon-mountain.svg"></div>
    </section>
<% } %>

<% if (id == 4) { %>
    <section aria-label="FAQs & event details" class="view view--content">
        <div class="view__in">
            <div class="group group--content">
                <div class="group__item">
                    <div class="view__anchor" id="faq"></div>
                    <div class="copy">
                        <h2>FAQ<sub>s</sub></h2>
                        <ul>
                            <li>
                                <strong>How can I contact the organization with any questions?</strong>
                                <p><a id="faq-email" href="mailto:customerservice@achievesummit.com">customerservice@achievesummit.com</a> or <a href="tel:1-800-203-4489" id="faq-phone">1-800-203-4489</a></p>
                            </li>
                            <li>
                                <strong>Is my registration/ticket transferable?</strong>
                                <p>Yes, at will call the day of the event.</p>
                            </li>
                            <li>
                                <strong>Can I get a group discount?</strong>
                                <p>Call or email customer service for groups of 10 or more. </p>
                            </li>
                            <li>
                                <strong>What can/can't I bring to the event?</strong>
                                <p>Bring pen and paper to take notes. No outside food or drink is permitted in the venue.</p>
                            </li>
                            <li>
                                <strong>What is the dress code?</strong>
                                <p>Dress code is business casual.</p>
                            </li>
                        </ul>
                    </div>
                </div>
                <% if (!isRoot)
                { %>
                <div class="group__item group__item--event">
                    <div class="view__anchor" id="event"></div>
                    <%=Html.Partial("EventDetails") %>
                </div>
                <% } %>
            </div>
        </div>
    </section>
<% } %>

<% if (id == 5) { %>
    <footer class="view view--contrast footer">
        <div class="view__in">

            <div class="contain">
                <% Html.RenderOfferDetails(); %>
            </div>

        </div>
    </footer>    
<% } %>

<% if (id == 6) { %>
    <% if (isRoot && !isIndex) {
        Html.RenderPartial("_AlertBanner");
    } %>
<% } %>