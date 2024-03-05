<%@ Control Language="C#" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var currentMonth = DateTime.Today.ToString("MM");
    var expirationMonthValues = new Dictionary<string, string>();
    var startDate = new DateTime(2008, 1, 1);

    for (var m = 0; m < 12; m++)
    {
        expirationMonthValues.Add(startDate.AddMonths(m).ToString("MM"), startDate.AddMonths(m).ToString("MM - MMM"));
    }
%>

<%--// BEGIN #paymentForm --%>
<fieldset class="c-brand--form__fieldset c-brand--form__fieldset--borderless" id="paymentForm">

    <%-- // @PAYMENT HEADLINE --%>
    <div class="c-brand--form__legend u-vw--100" tabindex="0">
        <h3 class="c-brand--form__headline">
            <%= LabelsManager.Labels["PaymentHeadline"] %>
        </h3>
    </div>

    <ul class="c-brand--form__list @mv-u-pad--vert">

        <%-- // @PAYMENT ICONS --%>
        <li class="c-brand--form__item o-grid--vert--center u-vw--100">
            <div id="cc" class="c-brand--form__field o-grid__col @xs-u-bs--reset @xs-u-vw--100"></div>
        </li>

        <%-- // @PAYMENT TYPE --%>
        <li id="CardTypeCt" class="c-brand--form__item o-grid--vert--center u-vw--100">
            <label for="CardType" data-required class="c-brand--form__label @mv-o-grid--none o-grid__col @xs-u-vw--40 fn--right">Type</label>
            <%= Html.DropDownList("CardType", new[]
                            {
                              new SelectListItem { Text = "Visa", Value = "V"},
                              new SelectListItem { Text = "Mastercard", Value = "M"},
                              new SelectListItem { Text = "Discover", Value = "D"},
                              new SelectListItem { Text = "American Express", Value= "AX"}
						  }, new { @class = "c-brand--form__select o-box o-shadow u-vw--100 fx--animate" })
            %>
        </li>

        <%-- // @PAYMENT NUMBER --%>
        <li id="CardNumberCt" class="c-brand--form__item o-grid--vert--center u-vw--100">
            <label id="CardNumberLabel" for="CardNumber" data-required class="c-brand--form__label @mv-o-grid--none o-grid__col @xs-u-vw--40 fn--right"><%= LabelsManager.Labels["CardNumber"] %></label>
            <input id="CardNumber" name="CardNumber" type="tel" value="<%= ViewData["CardNumber"] %>" placeholder="<%= LabelsManager.Labels["CardNumberPlaceholder"] %>" aria-labelledby="CardNumberLabel" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
        </li>

        <%-- // @PAYMENT EXP. DATE --%>
        <li id="CardExpirationCt" class="o-grid--vert--center u-vw--100 c-brand--form__item">
            <label for="CardExpirationMonth" data-required class="@mv-o-grid--none o-grid__col @xs-u-vw--40 fn--right c-brand--form__label"><%= LabelsManager.Labels["ExpirationDate"] %></label>
            <div class="c-brand--form__field o-grid @xs-u-vw--100 u-bs--reset">
                <div class="o-grid__col u-vw--50 u-pad--right">
                    <%--<%= Html.CardExpirationMonth("CardExpirationMonth", currentMonth, new { @class = "c-brand--form__select o-box o-shadow u-vw--100 fx--animate" }) %>--%>
                    <select class="c-brand--form__select o-box o-shadow u-vw--100 fx--animate u-vw" id="CardExpirationMonth" name="CardExpirationMonth">
                        <%
                            foreach (var option in expirationMonthValues)
                            {
                        %>
                        <option <%if (option.Key == currentMonth)
                            { %>
                            selected <%} %> value="<%=option.Key%>"><%=option.Value%></option>
                        <%
                            }
                        %>
                    </select>
                </div>
                <div class="o-grid__col u-vw--50 u-pad--left">
                    <%= Html.NumericDropDown("CardExpirationYear", DateTime.Now.Year, DateTime.Now.Year + 10, ViewData["CardExpirationYear"], new { @class = "c-brand--form__select o-box o-shadow u-vw--100 fx--animate" }) %>
                </div>
            </div>
        </li>

        <%-- // @PAYMENT CVV2 --%>
        <li id="CardCvv2Ct" class="c-brand--form__item o-grid--vert--center u-vw--100">
            <label id="CardCvv2Label" for="CardCvv2" data-required class="c-brand--form__label @mv-o-grid--none o-grid__col @xs-u-vw--40 fn--right"><%= LabelsManager.Labels["CVV2"] %></label>
            <div class="c-brand--form__field o-grid @xs-u-vw--100 u-bs--reset">
                <div class="o-grid__col u-vw--50 u-bs--reset u-pad--right">
                    <input id="CardCvv2" name="CardCvv2" type="tel" value="<%= ViewData["CardCvv2"] %>" maxlength="5" placeholder="<%= LabelsManager.Labels["CVV2Placeholder"] %>" aria-labelledby="CardCvv2Label" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
                </div>
                <div class="o-grid__col u-vw--50 u-bs--reset u-pad--left">
                    <a href="<%= LabelsManager.Labels["CVV2DisclaimerLink"] %>" title="<%= LabelsManager.Labels["CVV2DisclaimerLinkTitle"] %>" id="cvv2" class="c-brand--form__hint o-grid__col @xs-u-vw--100 u-pad u-push--left has-fancybox fancybox.ajax"><%= LabelsManager.Labels["CVV2Disclaimer"] %></a>
                </div>
            </div>
        </li>

    </ul>
</fieldset>
<%--// END #paymentForm --%>