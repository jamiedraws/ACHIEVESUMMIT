<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<% 
    var formTitle = SettingsManager.ContextSettings["Seminar.Template.Form.FormTitle--Form--", "Tell Us About Yourself"];
    var disclaimer = SettingsManager.ContextSettings["Seminar.Template.Form.Disclaimer--Form--", string.Empty];
%>

<div id="form" class="form__register u-mar--top" data-seminar-form="register__form">

    <div class="u-vw--100">

        <fieldset class="c-brand--form__borderless c-brand--form__fieldset no-border">

            <ul class="c-brand--form__list c-brand--form__item c-brand--form__borderless o-grid--vert--center u-vw--100">

                <li id="BillingFirstNameCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--right">
                    <label id="BillingFirstNameLabel" for="BillingFirstName" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100">First Name</label>
                    <input id="BillingFirstName" maxlength="50" name="BillingFirstName" type="text" value="<%= ViewData["BillingFirstName"] %>" placeholder="*First Name" aria-labelledby="BillingFirstNameLabel" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
                </li>
                <li id="BillingLastNameCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--left">
                    <label id="BillingLastNameLabel" for="BillingLastName" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100">Last Name</label>
                    <input id="BillingLastName" maxlength="50" name="BillingLastName" type="text" value="<%= ViewData["BillingLastName"] %>" placeholder="*Last Name" aria-labelledby="BillingLastNameLabel" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
                </li>

            </ul>

            <ul class="c-brand--form__list c-brand--form__item o-grid--vert--center c-brand--form__borderless u-vw--100">

                <li id="BillingStreetCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--right">
                    <label id="BillingStreetLabel" for="BillingStreet" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100"><%= LabelsManager.Labels["Address"] %></label>
                    <div class=" @xs-u-bs--reset fld">
                        <input id="BillingStreet" name="BillingStreet" autocomplete="new-password" type="text" value="<%= ViewData["BillingStreet"] %>" maxlength="50" placeholder="<%= LabelsManager.Labels["AddressPlaceholder"] %>" aria-labelledby="BillingStreetLabel" aria-required="true" class="c-brand--form__input o-box o-shadow @xs-u-vw--100 fx--animate">
                    </div>
                </li>

                <li id="BillingStreet2Ct" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--left">
                    <label id="BillingStreet2Label" for="BillingStreet2" class="c-brand--form__label o-grid--block @xs-u-vw--100"><%= LabelsManager.Labels["Address2"] %></label>
                    <input id="BillingStreet2" name="BillingStreet2" type="text" value="<%= ViewData["BillingStreet2"] %>" maxlength="50" placeholder="<%= LabelsManager.Labels["Address2Placeholder"] %>" aria-labelledby="BillingStreet2Label" aria-required="false" class="c-brand--form__input o-box o-shadow @xs-u-vw--100 fx--animate">
                </li>

            </ul>

            <ul class="c-brand--form__list c-brand--form__item o-grid--vert--center c-brand--form__borderless u-vw--100">

                <li id="BillingCityCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--right">
                    <label id="BillingCityLabel" for="BillingCity" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100"><%= LabelsManager.Labels["City"] %></label>
                    <input id="BillingCity" name="BillingCity" type="text" value="<%= ViewData["BillingCity"] %>" maxlength="50" placeholder="<%= LabelsManager.Labels["CityPlaceholder"] %>" aria-labelledby="BillingCityLabel" aria-required="true" class="c-brand--form__input o-box o-shadow @xs-u-vw--100 fx--animate">
                </li>

                <li id="BillingStateCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--left">
                    <label id="BillingStateLabel" for="BillingState" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100"><%= LabelsManager.Labels["State"] %></label>
                    <%= Html.DropDownListFor(m => m.BillingState, new SelectList(Model.States, "StateCode", "StateName"), LabelsManager.Labels["StatePlaceholder"], new { @class = "c-brand--form__select o-box o-shadow @xs-u-vw--100 fx--animate" }) %>
                </li>

            </ul>

            <div class="hide c-brand--form__list c-brand--form__item o-grid--vert--center c-brand--form__borderless u-vw--100">
                <label id="BillingCountryLabel" for="BillingCountry" data-required class="c-brand--form__label @mv-o-grid--none o-grid__col @xs-u-vw--40 fn--right"><%= LabelsManager.Labels["Country"] %></label>
                <%= Html.DropDownListFor(m => m.BillingCountry, new SelectList(Model.Countries, "CountryCode", "CountryName"), LabelsManager.Labels["CountryPlaceholder"], new { @class = "c-brand--form__select o-box o-shadow @xs-u-vw--100 fx--animate" }) %>
            </div>

            <ul class="c-brand--form__list c-brand--form__item o-grid--vert--center c-brand--form__borderless u-vw--100">

                <li id="PhoneCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--right">
                    <label id="PhoneLabel" for="Phone" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100">Phone</label>
                    <input id="Phone" name="Phone" type="tel" value="<%= ViewData["Phone"] %>" maxlength="50" placeholder="*Phone Number" aria-labelledby="PhoneLabel" aria-required="true" class="c-brand--form__input o-box o-shadow @xs-u-vw--100 fx--animate">
                </li>

                <li id="BillingZipCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 @sm-u-pad--reset u-pad--left">
                    <label id="BillingZipLabel" for="BillingZip" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100">Zip</label>
                    <input id="BillingZip" name="BillingZip" type="tel" value="<%= ViewData["BillingZip"] %>" maxlength="50" placeholder="*Zip Code" aria-labelledby="BillingZipLabel" aria-required="true" class="c-brand--form__input o-box o-shadow @xs-u-vw--100 fx--animate">
                </li>

            </ul>

            <ul class="c-brand--form__list c-brand--form__item o-grid--vert--center c-brand--form__borderless u-vw--100">

                <li id="EmailCt" class="c-brand--form__item o-grid__col @sm-u-vw--50 u-pad--reset">
                    <label id="EmailLabel" for="Email" data-required class="c-brand--form__label o-grid--block @xs-u-vw--100">Email</label>
                    <input id="Email" name="Email" type="email" value="<%= ViewData["Email"] %>" maxlength="50" placeholder="*Email" aria-labelledby="EmailLabel" aria-required="true" class="c-brand--form__input o-box o-shadow @xs-u-vw--100 fx--animate">
                </li>

            </ul>
         
            <ul data-seminar-register class="c-brand--form__register c-brand--form__list c-brand--form__borderless">
                <%if (Dtm.Framework.ClientSites.SettingsManager.ContextSettings["Seminar.Template.Form.EnableCellPhone--Form--", false]) {%>
                <li id="CellPhoneCt" class="c-brand--form__item o-grid--vert--center u-vw--100 center-text">
                    <% if (!String.IsNullOrEmpty(disclaimer))
                        { %>
                    <p class="c-brand--form__disclaimer bottom-margin">Enter your cell phone number below to receive a text message reminder for this event.**</p>
                    <% } %>
                    <label id="CellPhoneLabel" for="CellPhone" class="c-brand--form__label o-grid--block fn--left">Cell Phone</label>
                    <input id="CellPhone" name="CellPhone" type="tel" value="<%= ViewData["CellPhone"] %>" maxlength="50" placeholder="Cell Phone" aria-labelledby="CellPhoneLabel" aria-required="true" class="c-brand--form__input o-box o-shadow @xs-u-vw--100 fx--animate">
                    <p class="top-margin">Standard text message rates apply.</p>
                </li>
                <%} %>
            </ul>

        </fieldset>

    </div>

</div>
