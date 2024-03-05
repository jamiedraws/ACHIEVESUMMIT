<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<Dtm.Framework.ClientSites.Web.ClientSiteViewData>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%@ Import Namespace="System.Web.Script.Serialization" %>
    <%@ Import Namespace="Dtm.Framework.ClientSites" %>
    <%@ Import Namespace="Newtonsoft.Json.Linq" %>

    <%
        var enableCellPhone = SettingsManager.ContextSettings["Form.EnableCellPhone", true];

        var customErrorsSetting = SettingsManager.ContextSettings["PaymentProcessing.CustomErrors"];
        if (!string.IsNullOrEmpty(customErrorsSetting))
        {
            var paymentTransactions = DtmContext.Order != null ? DtmContext.Order.PaymentTransactions : null;
            if (paymentTransactions != null && paymentTransactions.Any())
            {
                var transaction = paymentTransactions.OrderByDescending(pt => pt.AddDate).FirstOrDefault();
                try
                {
                    var customErrors = JArray.Parse(customErrorsSetting);

                    foreach (var customError in customErrors)
                    {
                        var processor = customError.Value<string>("Processor") ?? string.Empty;
                        var resultCode = customError.Value<string>("ResultCode") ?? string.Empty;
                        var message = customError.Value<string>("Message") ?? string.Empty;

                        if (transaction != null
                            && transaction.ResultCode.Equals(resultCode, StringComparison.InvariantCultureIgnoreCase)
                            && transaction.ProcessorCode.Equals(processor, StringComparison.InvariantCultureIgnoreCase))
                        {
                            ViewData.ModelState.AddModelError("Form", message);
                        }
                    }
                }
                catch { }
            }
        }
    %>

    <link type="text/css" rel="stylesheet" href="<%= Url.Content("~/shared/css/processPayment.css") %>" />


    <div id="dtm_processPayment" class="dtm dtm__processpayment">

        <div class="dtm__in <%= Model.IsMobile ? "dtm__in--mv" : "dtm__in--dv" %> bg--white">

            <div id="dtm_form" class="c-brand--form">

                <% Html.BeginForm(); %>

                <div class="c-brand--form__list">
                    <div class="vse">
                        <%= Html.ValidationSummary("The following errors have occured:") %>
                    </div>

                    <%-- // BEGIN #paymentForm --%>
                    <div id="dtm_paymentForm" class="c-brand--form__fieldset">

                        <%-- // @PAYMENT HEADLINE --%>
                        <div class="c-brand--form__legend u-vw--100 c-brand--form__FormHeadlineL" tabindex="0">
                            <h3 class="c-brand--form__headline">Credit Card Information</h3>
                        </div>

                        <div id="cc"></div>

                        <%= Html.Hidden("CardPaymentAttempt") %>
                        <%= Html.BeginFieldContainer("CardType", "Type", true) %>
                        <%= Html.DropDownList("CardType", new[]
					            {
					            	new SelectListItem { Text = "Visa", Value = "V"},
					           		new SelectListItem { Text = "Mastercard", Value = "M"},
					            	new SelectListItem { Text = "Discover", Value = "D"},
					            	new SelectListItem { Text = "American Express", Value= "AX"}
					            }, new { @class = "c-brand--form__select o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("CardNumber", "Card Number", true)%>
                        <%= Html.TextBox("CardNumber", ViewData["CardNumber"], new { maxlength = "20", type = "tel", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("CardExpiration", "Expiration Date", true) %>
                        <div id="expirationDateDiv">
                        <%= Html.CardExpirationMonth("CardExpirationMonth", new { @class = "c-brand--form__select o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.NumericDropDown("CardExpirationYear", DateTime.Now.Year, DateTime.Now.Year + 10, Model.CardExpirationYear, new { @class = "c-brand--form__select o-box o-shadow @xs-u-vw--100 fx--animate" }) %>
                        </div>
                            <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("CardCvv2", "CVV2", true) %>
                        <input id="CardCvv2" name="CardCvv2" type="tel" value="<%= ViewData["CardCvv2"] %>" maxlength="5" placeholder="CVV2" aria-labelledby="CardCvv2Label" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
                        <span class="hint">
                            <a href="/Shared/cvv.html" title="Learn more about CVV2" class="has-fancybox fancybox.ajax">What is CVV2?</a>
                        </span>
                        <%= Html.EndFieldContainer() %>
                    </div>

                </div>

                <div class="c-brand--form__list">

                    <div id="dtm_billingInformation" class="c-brand--form__fieldset">
                        <%-- // @PAYMENT HEADLINE --%>
                        <div class="c-brand--form__legend u-vw--100 c-brand--form__FormHeadlineL" tabindex="0">
                            <h3 class="c-brand--form__headline">Billing Information</h3>
                        </div>

                        <%= Html.BeginFieldContainer("BillingFirstName", "First Name", true ) %>
                        <%= Html.TextBox("BillingFirstName", Model.BillingFirstName, new { maxlength="50", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("BillingLastName", "Last Name", true)%>
                        <%= Html.TextBox("BillingLastName", ViewData["BillingLastName"], new { maxlength = "50", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("BillingStreet", "Address", true)%>
                        <%= Html.TextBox("BillingStreet", ViewData["BillingStreet"], new { maxlength = "50", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("BillingStreet2", "Address 2", false)%>
                        <%= Html.TextBox("BillingStreet2", ViewData["BillingStreet2"], new { maxlength = "50", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("BillingCity", "City", true)%>
                        <%= Html.TextBox("BillingCity", ViewData["BillingCity"], new { maxlength = "50", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%--<%= Html.Hidden("BillingCountry", 1)%>--%>
                        <%= Html.BeginFieldContainer("BillingCountry", "Country", true)%>
                        <%= Html.DropDownList("BillingCountry", new SelectList(Model.Countries, "CountryCode", "CountryName"), "Choose Country", new { @class = "c-brand--form__select o-box o-shadow @xs-u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("BillingState", "State", true)%>
                        <%= Html.DropDownList("BillingState", new SelectList(Model.States, "StateCode", "StateName"), "Choose State", new { @class = "c-brand--form__select o-box o-shadow @xs-u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("BillingZip", "Zip", true)%>
                        <%= Html.TextBox("BillingZip", ViewData["BillingZip"], new { maxlength="10", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("Phone", "Phone", true)%>
                        <%= Html.TextBox("Phone", ViewData["Phone"], new { type = "tel", maxlength = "15", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%= Html.BeginFieldContainer("Email", "Email", true)%>
                        <%= Html.TextBox("Email", ViewData["Email"], new { type = "email", maxlength = "100", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>

                        <%if (enableCellPhone) { %>
                        <%= Html.BeginFieldContainer("CellPhone", "CellPhone", false)%>
                        <%= Html.TextBox("CellPhone", ViewData["CellPhone"], new { type = "tel", maxlength = "100", @class = "c-brand--form__input o-box o-shadow u-vw--100 fx--animate" }) %>
                        <%= Html.EndFieldContainer() %>
                        <%} %>
                    </div>

                    <div class="hide">
                        <%= Html.Hidden("ShippingFirstName", DtmContext.Order.ShippingFirstName)%>
                        <%= Html.Hidden("ShippingLastName", DtmContext.Order.ShippingLastName)%>
                        <%= Html.Hidden("ShippingStreet", DtmContext.Order.ShippingStreet)%>
                        <%= Html.Hidden("ShippingStreet2", DtmContext.Order.ShippingStreet2)%>
                        <%= Html.Hidden("ShippingCity", DtmContext.Order.ShippingCity)%>
                        <%= Html.Hidden("ShippingState", DtmContext.Order.ShippingState)%>
                        <%= Html.Hidden("ShippingCountry", DtmContext.Order.ShippingCountry)%>
                        <%= Html.Hidden("ShippingZip", DtmContext.Order.ShippingZip)%>
                        <% if (DtmContext.Order.ShippingIsSameAsBilling == false)
                            { %>
                        <input id="Hidden1" name="ShippingIsDifferentThanBilling" type="hidden" value="true">
                        <% }
                            else
                            { %>
                        <input id="Hidden2" name="ShippingIsDifferentThanBilling" type="hidden" value="false">
                        <% } %>
                    </div>

                </div>

                <div id="continueButton" class="FormSubmit">
                    <span id="submitBtn">
                        <input type="submit" name="acceptOffer" class="confirm-button" value="Continue">
                    </span>
                </div>

                <% Html.EndForm(); %>
            </div>

        </div>

    </div>

</asp:Content>
