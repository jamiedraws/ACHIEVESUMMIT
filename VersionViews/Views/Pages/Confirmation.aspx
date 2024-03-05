<%@ Page Title="Dotza" Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<ClientSiteViewData>" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <% 
        var FormType = SettingsManager.ContextSettings["Seminar.Template.Form.FormType--Form--", string.Empty];
        var Use24HourClock = SettingsManager.ContextSettings["Seminar.Template.Use24HourFormat", false];
        var timeFormatString = (Use24HourClock) ? "H:mm" : "h:mm tt";

        var enableInviteAGuest = SettingsManager.ContextSettings["InviteAGuest.Enable", true];
        var enableTicket = SettingsManager.ContextSettings["Seminar.Template.Form.EnableTicket--Form--", true];

        var enableFacebook = SettingsManager.ContextSettings["SocialPlugins.Facebook.EnableShare", true];
        var enablePinterest = SettingsManager.ContextSettings["SocialPlugins.Pinterest.Enable", false];
        var enableLinkedIn = SettingsManager.ContextSettings["SocialPlugins.LinkedIn.EnableShare", false];
        var enableTwitter = SettingsManager.ContextSettings["SocialPlugins.Twitter.Enable", false];

        var showSocialMedia = !enableFacebook && !enablePinterest && !enableLinkedIn && !enableTwitter ? false : true;

        var getDescription = SettingsManager.ContextSettings["Label.MetaDescription"];
        var getPinterestImage = SettingsManager.ContextSettings["SocialPlugins.Pinterest.MediaImage"];
        var getPinterestDescription = SettingsManager.ContextSettings["SocialPlugins.Pinterest.MetaDescription", getDescription ?? Model.PageTitle];

        var mid = "?mid=";
        var getFacebookMID = SettingsManager.ContextSettings["SocialPlugins.Facebook.MID"] ?? string.Empty;
        var getTwitterMID = SettingsManager.ContextSettings["SocialPlugins.Twitter.MID"] ?? string.Empty;
        var getLinkedInMID = SettingsManager.ContextSettings["SocialPlugins.LinkedIn.MID"] ?? string.Empty;
        var getPinterestMID = SettingsManager.ContextSettings["SocialPlugins.Pinterest.MID"] ?? string.Empty;

        getFacebookMID = !String.IsNullOrEmpty(getFacebookMID) ? mid + getFacebookMID : getFacebookMID;
        getTwitterMID = !String.IsNullOrEmpty(getTwitterMID) ? mid + getTwitterMID : getTwitterMID;
        getLinkedInMID = !String.IsNullOrEmpty(getLinkedInMID) ? mid + getLinkedInMID : getLinkedInMID;
        getPinterestMID = !String.IsNullOrEmpty(getPinterestMID) ? mid + getPinterestMID : getPinterestMID;

        var location = Model.Locations.AllSeminars.FirstOrDefault();
        var date = location != null ? location.SeminarDate : new DateTime();
        var time = location != null ? location.SeminarTimes.FirstOrDefault() : null;
    %>

    <section class="c-brand c-brand--register">

        <div class="ad-header reOfferHeadline">
            <h2>Thank you for registering!</h2>
            <br />
            <h2><small>Your confirmation number is: <%=Model.Order.OrderID %></small></h2>
        </div>

        <%
            var addressOptions = new ViewDataDictionary {
            {"removeColumns", "shipping" }
        };
	%>

        <div class="u-mar">
            <%=Html.Partial("GetAddressDetails", Model, addressOptions)%>
        </div>

        <div class="c-brand--form u-mar">
            <div class="c-brand--form__fieldset">
                <div class="c-brand--form__legend u-vw--100">
                    <h3 class="c-brand--form__headline">Your Order Summary</h3>
                </div>
                <div class="c-brand--form__table">
                    <%=Html.Partial("SummaryReview")%>
                </div>
            </div>
        </div>


        <div class="c-brand--form u-mar">
            <div class="c-brand--form__fieldset">
                <div class="c-brand--form__legend u-vw--100">
                    <h3 class="c-brand--form__headline">Event Details</h3>
                </div>
                <div class="group group--event">
                    <div class="group__item group__item--event">
                        <%= Html.Partial("EventDetails") %>
                    </div>
                    <div class="group__item group__item--actions">
                        <% if (showSocialMedia)
                            { %>
                        <div class="c-brand--box c-brand--register__social">
                            <h2 class="c-brand__headline--box">Share This Event</h2>
                            <hr>
                            <ul class="row center-margin social">
                                <% if (enableFacebook)
                                { %>
                                <li class="column-block">
                                    <a class="is-clickable social__link social__facebook" href="https://www.facebook.com/sharer/sharer.php?u=<%= DtmContext.Domain.FullDomainOfferVersionContext %><%= getFacebookMID %>" target="_blank">
                                        <span class="icon-facebook"></span>
                                    </a>
                                </li>
                                <% } %>

                                <% if (enableLinkedIn)
                                { %>
                                <li class="column-block">
                                    <a class="is-clickable social__link" href="https://www.linkedin.com/shareArticle?mini=true&url=<%= DtmContext.Domain.FullDomainOfferVersionContext %><%= getLinkedInMID %>" target="_blank">
                                        <span class="icon-linkedin2"></span>
                                    </a>
                                </li>
                                <% } %>

                                <% if (enableTwitter)
                                { %>
                                <li class="column-block">
                                    <a class="is-clickable social__link" href="https://twitter.com/intent/tweet?&url=<%= DtmContext.Domain.FullDomainOfferVersionContext %><%= getTwitterMID %>" target="_blank">
                                        <span class="icon-twitter"></span>
                                    </a>
                                </li>
                                <% } %>

                                <% if (enablePinterest)
                                { %>
                                <li class="column-block">
                                    <a class="is-clickable social__link" href="https://pinterest.com/pin/create/button/?url=<%= DtmContext.Domain.FullDomainOfferVersionContext %><%= getPinterestMID %>&amp;media=<%= DtmContext.Domain.FullDomainContext %><%= getPinterestImage %>&amp;description=<%= getPinterestDescription %>" target="_blank">
                                        <span class="icon-pinterest"></span>
                                    </a>
                                </li>
                                <% } %>
                            </ul>
                        </div>
                        <% } %>

                        <div class="c-brand--confirm c-brand--register__reminder">
                            <h2 class="c-brand--box c-brand__headline--box">Reminder &amp; Location</h2>
                            <% using (Html.BeginForm())
                            { %>
                            <ul class="u-vw--100 c-list--reset u-pad fn--center">
                                <% if (enableTicket)
                                { %>
                                <li>
                                    <a class="@sm-u-vw--90 o-box--btn--icon fx--animate" target="_blank" href="/ViewTicket" title="View &amp; Print eTicket">
                                        <span class="icon-ticket u-mar--right"></span>View &amp; Print eTicket
									</a>
                                </li>
                                <% } %>
                                <% if (enableInviteAGuest)
                                { %>
                                <li>
                                    <a href="#invite-friend" class="@sm-u-vw--90 has-fancybox o-box--btn--icon fx--animate">
                                        <span class="icon-user-plus u-mar--right"></span>Invite A Guest
										</a>
                                </li>
                                <% } %>
                                <li>
                                    <div id="calReminder" class="@sm-u-vw--90 o-box--btn--icon fx--animate">
                                        <span>
                                            <span class="icon-alarm u-mar--right"></span>Add To Calendar
                                        </span>
                                        <div id="calType" class="cal @js-only-hide">
                                            <a id="gcal" target="_blank" class="flat-button" title="Set a reminder for this event on Google calendar" href="/Shared/Services/OnlineCalendarService.ashx?id=<%= time.ProductCode %>&o=<%=DtmContext.OfferCode%>&v=<%=DtmContext.Version%>&ct=google">Google</a>

                                            <a id="owacal" target="_blank" class="flat-button" title="Set a reminder for this event on Outlook calendar" href="/Shared/Services/OnlineCalendarService.ashx?id=<%= time.ProductCode %>&o=<%=DtmContext.OfferCode%>&v=<%=DtmContext.Version%>&ct=outlook">Outlook</a>

                                            <a id="ycal" target="_blank" class="flat-button" title="Set a reminder for this event on Yahoo calendar" href="/Shared/Services/OnlineCalendarService.ashx?id=<%= time.ProductCode %>&o=<%=DtmContext.OfferCode%>&v=<%=DtmContext.Version%>&ct=yahoo">Yahoo</a>

                                            <a id="ocal" target="_blank" class="flat-button" title="Set a reminder for this event on a calendar" href="/Shared/Services/AppointmentService.ashx?id=<%= time.ProductCode %>&o=<%=DtmContext.OfferCode%>&v=<%=DtmContext.Version%>">Other</a>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <button type="submit" class="@sm-u-vw--90 o-box--btn--icon u-mar--center fx--animate" name="createOrder">
                                        <span class="icon-home u-mar--right"></span>Back to Home Page
									
                                    </button>
                                </li>
                            </ul>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </section>

    <style>
        .footer nav {
            display: none;
        }
    </style>

</asp:Content>
