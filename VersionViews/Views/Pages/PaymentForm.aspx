<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<Dtm.Framework.ClientSites.Web.ClientSiteViewData>" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%=Html.Partial("OrderFlowPhase") %>

    <div class="vse">
        <%= Html.ValidationSummary("The following errors have occured:") %>
    </div>
    <% using (Html.BeginForm())
        { %>
    <div class="c-brand--form">
        <div class="c-brand--form__fieldset">
            <div class="c-summary__group">
                <div class="c-brand--form__legend u-vw--100">
                    <h3 class="c-brand--form__headline">Your Order Summary</h3>
                </div>
                <div class="c-brand--form__table">
                    <%--<%= Html.Partial("SummaryReview", Model) %>--%>
                    <%=Html.Partial("OrderFormReviewTable", Model) %>
                </div>
            </div>
        </div>
    </div>
    <div class="c-brand--form">
        <div class="c-brand--form__fieldset">
            <div class="c-brand--form__legend u-vw--100">
                <h3 class="c-brand--form__headline">Payment and Billing Information</h3>
            </div>
            <div class="c-payment">

                <span class="loader">
                    <span class="loader__animation"></span>
                </span>

                <%-- // Indicate Requires Field --%>
                <p data-required class="indicate u-mar--bottom fn--center"><%= LabelsManager.Labels["RequiredFieldDisclaimer"] %></p>

                <div class="c-payment__group">
                    <div class="c-payment__item">
                        <% 
                            //CC info
                            Html.RenderPartial("PaymentInfo");
                        %>
                    </div>
                    <div class="c-payment__item c-payment__divide">
                        <div id="billingInformation" class="c-payment__divide--group">
                            <div class="c-brand--form__legend u-vw--100" tabindex="0">
                                <h3 class="c-brand--form__headline">Enter Your Billing Information
                                </h3>
                            </div>
                            <%
                                var formType = SettingsManager.ContextSettings["Seminar.Template.Form.FormType--Form--", string.Empty];
                                var partialName = "FormHTML-" + formType.Replace(" ", "-");
                                var defaultView = "FormHTML-US-Short";
                                if (defaultView != partialName && ViewEngines.Engines.FindPartialView(ViewContext.Controller.ControllerContext, partialName).View != null)
                                {
                                    Html.RenderPartial(partialName, Model);
                                }
                                else
                                {
                                    Html.RenderPartial(defaultView, Model);
                                }
                            %>
                        </div>
                    </div>
                </div>
                <fieldset class="FormSubmit c-brand--form__fieldset c-brand--form__fieldset--borderless" id="calltoAction">
                    <ul class="c-brand--form__list @mv-u-pad--vert @dv-u-pad--horz center-text">
                        <%-- // @PROCESS ORDER BUTTON --%>
                        <li class="c-brand--form__item o-grid--vert--center u-vw--100 u-mar--vert">
                            <button type="submit" id="AcceptOfferButton" aria-labelledby="acceptOffer" name="acceptOffer" class="button center-margin"><%= SettingsManager.ContextSettings["Seminar.Template.Form.SubmitButtonText--Form--", "Continue"] %></button>
                        </li>
                        <li class="c-brand--form__item c-brand--form__terms u-vw--100">
                            <label for="TermsCbx">
                                <input type="hidden" name="Terms" id="Terms" value="False" />
                                <input data-eflex="draw" type="checkbox" name="TermsCbx" id="TermsCbx" onclick="updateCbx('Terms')" /><p>By checking this box, you agree to our <a data-fancybox-method="page" class="has-fancybox fancybox.iframe" href="Terms-Of-Service<%=DtmContext.ApplicationExtension %>">terms of service</a></p>
                            </label>
                            <label for="CellOptInCbx">
                                <input type="hidden" name="CellOptIn" id="CellOptIn" value="False" />
                                <input data-eflex="draw" type="checkbox" name="CellOptInCbx" id="CellOptInCbx" onclick="updateCbx('CellOptIn')" /><p>By checking this box, you consent to recieve text mesasges with important updates related to this event. These messages will be sent to the cell number provided by you. You may recieve up to 4 msgs/month. Message and data rates may apply. Text STOP to opt out or HELP for help. <a data-fancybox-method="page" class="has-fancybox fancybox.iframe" href="Privacy-Policy<%=DtmContext.ApplicationExtension %>">Privacy Policy</a>.</p>
                            </label>
                        </li>
                    </ul>

                </fieldset>

            </div>


        </div>
    </div>
    <% } %>
    <script type="text/javascript">
        function updateCbx(id) {
            const ele = document.getElementById(id);
            const self = document.getElementById(id + 'Cbx');
            if (self.checked) {
                ele.setAttribute("value", "True");
            } else {
                ele.setAttribute("value", "False");
            }
        }

        <%
        if (Model.IsMobile)
        {
        %>
        $(window).load(function () {
            $("#CardNumber").prop("placeholder", "Card Number");
            $("#CardCvv2").prop("placeholder", "CVV2");
        });
        <%
           }
        %>
    </script>
</asp:Content>

