<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%
    var enableOrderFormReviewTable = SettingsManager.ContextSettings["OrderFormReview.Enable", false];
    var enableEditableQuantity = SettingsManager.ContextSettings["OrderFormReview.EnableEditableQuantity", false];
    var enableClearCartOnAdd = SettingsManager.ContextSettings["OrderFormReview.EnableClearCartOnAdd", false];
    var readOnlyTable = SettingsManager.ContextSettings["OrderFormReview.ReadOnlyTable", false];
    var enableJumpToCartOnChange = SettingsManager.ContextSettings["OrderFormReview.EnableJumpToCartOnChange", false];
    var enableAddPhToSubtotal = SettingsManager.ContextSettings["OrderFormReview.EnableAddPhToSubtotal", false];
    var enableCustomCartMode = SettingsManager.ContextSettings["OrderFormReview.EnableCustomCartMode", false];
    var enableZeroQuantity = SettingsManager.ContextSettings["OrderFormReview.AllowZeroQuantityWhenEditable", true];
    var enableKeepItemIfZero = SettingsManager.ContextSettings["OrderFormReview.KeepItemIfZero", false] && enableEditableQuantity;
    var enableToggleShippingFields = SettingsManager.ContextSettings["OrderFormReview.EnableToggleShippingFields", false];

    var __afId = Request.QueryString["a"];
    var __subAfId = Request.QueryString["s"];
    var __clickId = Request.QueryString["clickID"];
    var __mediaId = Request.QueryString["mid"];

    var customCartPageCodes = (SettingsManager.ContextSettings["OrderFormReview.CustomCartModePageCodesCSV", string.Empty] ?? string.Empty)
                                        .Split(',');

    if (customCartPageCodes.Any(pc => !string.IsNullOrWhiteSpace(pc) && pc.Equals(DtmContext.PageCode, StringComparison.InvariantCultureIgnoreCase)))
    {
        enableCustomCartMode = true;
    }

    var showOrderFormReviewTable = SettingsManager.ContextSettings["OrderFormReview.ShowReviewTable", true];

    // Columns
    var showPriceColumn = SettingsManager.ContextSettings["OrderFormReview.ShowPriceColumn", false];
    var showShippingColumn = SettingsManager.ContextSettings["OrderFormReview.ShowShippingColumn", false];
    var showRemoveButtonColumn = SettingsManager.ContextSettings["OrderFormReview.ShowRemoveButtonColumn", false];

    // Footers
    var showSubTotalFooter = SettingsManager.ContextSettings["OrderFormReview.ShowSubTotalFooter", false];
    var showShippingFooter = SettingsManager.ContextSettings["OrderFormReview.ShowShippingFooter", false];
    var showStateTaxFooter = SettingsManager.ContextSettings["OrderFormReview.ShowStateTaxFooter", false];
    var showOrderTotalFooter = SettingsManager.ContextSettings["OrderFormReview.ShowOrderTotalFooter", true];
    var showSaleTaxLink = SettingsManager.ContextSettings["OrderFormReview.ShowSalesTax", true];
    var showShippingMessage = SettingsManager.ContextSettings["OrderFormReview.ShowShippingMessage", false];

    // Text
    var textItemColumn = SettingsManager.ContextSettings["OrderFormReview.ItemColumnText", "Item"];
    var textQuantityColumn = SettingsManager.ContextSettings["OrderFormReview.QuantityColumnText", "Quantity"];
    var textPriceColumn = SettingsManager.ContextSettings["OrderFormReview.PriceColumnText", "Price"];
    var textShippingColumn = SettingsManager.ContextSettings["OrderFormReview.ShippingColumnText", "P&H"];
    var textOrderTotalFooter = SettingsManager.ContextSettings["OrderFormReview.OrderTotalFooterText", "<b>Estimated Order Total</b>"];
    var textSubTotalFooter = SettingsManager.ContextSettings["OrderFormReview.SubTotalFooterText", "Sub Total:"];
    var textShippingFooter = SettingsManager.ContextSettings["OrderFormReview.ShippingFooterText", "Process & Handling"];
    var textStateTaxFooter = SettingsManager.ContextSettings["OrderFormReview.StateTaxFooterText", "State Tax:"];
    var textStepHeader = SettingsManager.ContextSettings["OrderFormReview.StepHeaderText", "<strong>STEP 2:</strong><br />Review your order"];
    var textSaleTaxLink = SettingsManager.ContextSettings["OrderFormReview.SalesTaxLink", "/shared/sales-tax.html"];
    var textSaleTaxLinkTitle = SettingsManager.ContextSettings["OrderFormReview.SalesTaxLinkTitle", "Sales Tax"];
    var textSaleTaxLinkText = SettingsManager.ContextSettings["OrderFormReview.SalesTaxLinkText", "Sales Tax Info"];
    var textSaleTaxPlaceHolder = SettingsManager.ContextSettings["OrderFormReview.SaleTaxBoxText", "Enter Zip Code"];
    var textShippingMessage = SettingsManager.ContextSettings["OrderFormReview.ShippingMessageText", "Standard ground delivery"];
    var textErrorMessage = SettingsManager.ContextSettings["OrderFormReview.ErrorMessageText", "The following errors have occured:"];

    //Table Label Variables
    var textFutureCharges = LabelsManager.Labels["FutureChargesText"] ?? "Future Charges";

    //Currency symbol
    var currencySymbol = SettingsManager.ContextSettings["OrderFormReview.CurrencySymbol", "$"];

    //SubTables
    var showFutureChargesSubTable = SettingsManager.ContextSettings["OrderFormReview.ShowFutureChargesSubTable", false];
    var showFullPaymentSummarySubTable = SettingsManager.ContextSettings["OrderFormReview.ShowFullPaymentSummarySubTable", false];

    //PromoCodes
    var showPromoCodeButton = SettingsManager.ContextSettings["OrderFormReview.ShowPromoCodeButton", false];

    var totalColumnLength = 1 + (showPriceColumn ? 1 : 0) + (showShippingColumn ? 1 : 0) + (showRemoveButtonColumn ? 1 : 0);

    var hiddenCodes = DtmContext.ShoppingCart.Where(s => s.CampaignProduct.ProductTypeId == 0).Select(s => s.ProductCode).ToList();
%>

<%if (enableOrderFormReviewTable)
    { %>
<%if (!enableCustomCartMode)
    { %>



<style>
    .alignTextRight {
        text-align: right;
    }

    .alignTextLeft {
        text-align: left;
    }

    .disableToggleClick {
        pointer-events: none;
    }
</style>

<table id="orderReview" class="orderItemsTable reviewTable">
    <thead class="reviewTableHead">
        <tr>
            <th>Item</th>
            <th>Description</th>
            <th><%=textQuantityColumn %></th>
            <%if (showPriceColumn)
                { %>
            <th><%=textPriceColumn %></th>
            <%} %>
            <%if (showShippingColumn)
                { %>
            <th><%=textShippingColumn %></th>
            <%} %>
            <%if (showRemoveButtonColumn)
                { %>
            <th></th>
            <%} %>
        </tr>
    </thead>
    <tbody class="reviewTableBody orderItemsTableBody">
    </tbody>
    <tfoot class="reviewTableFoot alignTextRight">
        <%if (showSubTotalFooter)
            { %>
        <tr>
            <td colspan="<%=totalColumnLength %>"><%=textSubTotalFooter %></td>
            <td>
                <label class="subtotal"></label>
            </td>
        </tr>
        <%} %>
        <%if (showShippingFooter)
            { %>
        <tr>
            <td colspan="<%=totalColumnLength %>"><%=textShippingFooter %></td>
            <td>
                <label class="phtotal"></label>
            </td>
        </tr>
        <%} %>
        <%if (showStateTaxFooter)
            { %>
        <tr>
            <td colspan="2" rowspan="4"></td>
            <td>
                <label for="zc">
                    <%=textStateTaxFooter%>
                </label>
            </td>
            <td>
                <span class="taxtotal"></span></td>
        </tr>
        <%} %>
        <%if (showOrderTotalFooter)
            { %>
        <tr>
            <td><%=textOrderTotalFooter %></td>
            <td>
                <span class="summary-total"></span></td>
        </tr>
        <%} %>
        <%if (showSaleTaxLink)
            {%>
        <tr>
            <td class="sales-tax-link" colspan="4" align="left"><b><a data-fancybox-url="<%= textSaleTaxLink %>" href="javascript:MM_openBrWindow('<%=textSaleTaxLink%>','window','scrollbars=yes,width=450,height=400,left=0,top=0');" title="<%=textSaleTaxLinkTitle%>"><%=textSaleTaxLinkText%></a></b></td>
        </tr>
        <%} %>
        <%if (showShippingMessage)
            {%>
        <tr>
            <td colspan="4" align="left"><%=textShippingMessage%></td>
        </tr>
        <%} %>
    </tfoot>
</table>

<div id="orderFormReviewTableItems">

    <% if (enableEditableQuantity && !enableKeepItemIfZero)
        {
            var cartItems = DtmContext.ShoppingCart.Where(s => s.CampaignProduct.ProductTypeId != 0).ToList();
            for (var i = 0; i < cartItems.Count; i++)
            {
                dynamic item = cartItems.ElementAt(i);
    %>
    <input type="hidden" id="ActionCode<%=i%>" name="ActionCode<%=i%>" value="<%=item.ProductCode%>" />
    <% if (item.GetType().GetProperty("ProductAttributeProductCode") != null)
        {%>
    <input type="hidden" id="ActionAttribute<%=i%>" name="ActionAttribute<%=i%>" value="<%=item.ProductAttributeProductCode as string%>" />
    <% }%>
    <select id="ActionQuantity<%=i%>" name="ActionQuantity<%=i%>">
        <option value="<%=item.Quantity%>" selected="selected"><%=item.Quantity%></option>
    </select>
    <%}%>
    <%}%>
</div>
<%} %>
<script type="text/javascript">
    var _firstIndex = '';
    var _firstRun = true;

    var cartItems = [];
    var modifierArray = [];

    function getCartUrl(type) {
        var m = '<%=__mediaId%>' == '' ? '' : 'mid=<%=__mediaId%>';
        var a = '<%=__afId%>' == '' ? '' : 'a=<%=__afId%>';
        var s = '<%=__subAfId%>' == '' ? '' : 's=<%=__subAfId%>';
        var c = '<%=__clickId%>' == '' ? '' : 'clickId=<%=__clickId%>';

        var arr = [m, a, s, c]

        for (var i = 0; i < arr.length; i++) {
            if (arr[i] == '') {
                arr.splice(i, 1);
                i--;
            }
        }

        var qs = (m + a + s + c) == '' ? '' : ('?' + arr.join('&'));

        var url = '/Cart/' + type + '/<%=DtmContext.PageCode%>' + qs;
        return url;
    }

    function loadAllItemStates() {
        var preloadedItems = [];
        var enableEditableQuantity = <%= enableEditableQuantity ? "true" : "false" %>;
        <%for (var i = 0; i < DtmContext.ShoppingCart.Count; i++)
    {
        var item = DtmContext.ShoppingCart.ElementAt(i); %>
            <%if (item.Quantity > 0)
    {%>
        loadItemState("<%=item.ProductCode%>", parseInt(<%=item.Quantity%>));

        //Custom Keep State Logic 
        if (typeof customLoadItemState == 'function') {
            customLoadItemState("<%=item.ProductCode%>", parseInt(<%=item.Quantity%>));
        }

        preloadedItems.push('<%=item.ProductCode%>');
            <%}%>
        <%}%>       

        if (preloadedItems.length > 0) {
            handleCartChange();
        } else if (!enableEditableQuantity) {
            handleCartChange();
        }

        $.each($('[data-condition-missing][data-condition-value]:not([data-condition])'), function () {
            var code = $(this).attr('data-condition-missing');
            var regex = new RegExp("^" + code + "$");
            var cartItem = _dtmShoppingCart.SearchItems(regex);
            if ((preloadedItems.length == 0 && cartItem.length <= 0) || (preloadedItems.length > 0 && preloadedItems.indexOf(code) <= 0)) {
                setDataCondition(this);
            }
        });
    }

    function checkboxToggleXor(removeItems) {

        for (var i = 0; i < removeItems.length; i++) {

            $('#' + removeItems[i] + '').prop('checked', false);
        }

    }

    function isSelectorModified(selector) {

        var isDataSelect = $(selector).is('select') && typeof $(selector).attr('data-select') !== "undefined";
        var isModified = false;

        if (isDataSelect) {
            var selectedOption = $(selector).find(':selected');
            isModified = ($(selector).attr('data-code-modifier') != null &&
                $(selector).attr('data-code-modifier').length > 0 &&
                $(selectedOption).attr('data-code-alt') != null &&
                $(selectedOption).attr('data-code-alt').length > 0 &&
                ($('#' + $(selector).attr('data-code-modifier')).is(':checked') || $('[name=' + $(selector).attr('data-code-modifier') + '][value=true]').is(':checked')));
        } else {
            isModified = ($(selector).attr('data-code-modifier') != null &&
                $(selector).attr('data-code-modifier').length > 0 &&
                $(selector).attr('data-code-alt') != null &&
                $(selector).attr('data-code-alt').length > 0 &&
                ($('#' + $(selector).attr('data-code-modifier')).is(':checked') || $('[name=' + $(selector).attr('data-code-modifier') + '][value=true]').is(':checked')));
        }

        return isModified;
    }

    function AddToModifierArray(modifierName) {

        var alreadyExists = false;
        if (modifierArray.length > 0) {
            modifierArray.forEach(function (ele) {
                if (ele == modifierName) {
                    alreadyExists = true;
                }
            });
        }
        if (!alreadyExists) {
            modifierArray.push(modifierName);
        }
    }

    function handleModifierChangeAction(name, type) {

        var modifiableSelectors = $('[data-code-modifier=' + name + ']');
        var datacode = "";
        var bonusArray = [];
        var removeItems = [];
        var firstSelectorQuantity = 0;
        var quantity = 0;

        switch (type) {
            case 'checkbox':
                var isModified = $('[name=' + name + ']').is(':checked');

                break;

            case 'radio':
                var isModified = $('[name=' + name + ']:checked').val() == 'true';

                break;
        }


        if (modifiableSelectors.length > 0) {

            for (var i = 0; i < modifiableSelectors.length; i++) {

                var element = $(modifiableSelectors[i]);
                var isSelect = element.is('select') && typeof element.attr('data-select') === "undefined";
                var isDataSelect = element.is('select') && typeof element.attr('data-select') !== "undefined";
                var isRadioOrCB = 'radio,checkbox'.indexOf(element.attr('type')) >= 0;

                if (i == 0) {

                    if (isSelect) {
                        firstSelectorQuantity = isSelect ? element.val() : 1;
                    }
                    else if (isDataSelect) {
                        firstSelectorQuantity = element.attr('data-qty-id') != null ? $('#' + element.attr('data-qty-id')).val() : 1;
                    }
                    else if (isRadioOrCB) {
                        if (element.is(':checked')) {

                            firstSelectorQuantity = element.attr('data-qty-id') != null ? $('#' + element.attr('data-qty-id')).val() : 1;
                        }
                    }

                    if (firstSelectorQuantity > 0) {

                        element = isDataSelect ? element.find(":selected") : element;
                        dataCode = isModified ? element.attr('data-code-alt') : isDataSelect ? element.val() : element.attr('data-code');

                        var bonusAddRemoveArrays = bonusItemHandler(isModified, firstSelectorQuantity, $(modifiableSelectors[i]));

                        bonusArray = bonusArray.concat(bonusAddRemoveArrays.bonusItems);
                        removeItems = removeItems.concat(bonusAddRemoveArrays.removeItems);

                        if (isDataSelect) {
                            removeItem = isModified ? element.val() : element.attr('data-code-alt');
                            removeItems.push(removeItem);
                        }


                    } else {
                        dataCode = "";
                    }

                }
                else {

                    if (isSelect) {
                        quantity = isSelect ? element.val() : 1;
                    }
                    else if (isDataSelect) {
                        quantity = element.attr('data-qty-id') != null ? $('#' + element.attr('data-qty-id')).val() : 1;
                    }
                    else if (isRadioOrCB) {
                        if (element.is(':checked')) {

                            quantity = element.attr('data-qty-id') != null ? $('#' + element.attr('data-qty-id')).val() : 1;
                        } else {
                            quantity = 0;
                        }
                    }
                    if (quantity > 0) {

                        var bonusAddRemoveArrays = bonusItemHandler(isModified, quantity, $(modifiableSelectors[i]));
                        element = isDataSelect ? element.find(":selected") : element;

                        var selector = isModified ? element.attr('data-code-alt') : isDataSelect ? element.val() : element.attr('data-code');

                        if (dataCode == "") {
                            dataCode = selector;
                            firstSelectorQuantity = quantity;
                        } else {
                            bonusArray.push({ Id: selector, Qty: quantity })
                        }

                        bonusArray = bonusArray.concat(bonusAddRemoveArrays.bonusItems);
                        removeItems = removeItems.concat(bonusAddRemoveArrays.removeItems);

                        if (isDataSelect) {
                            removeItem = isModified ? element.val() : element.attr('data-code-alt');
                            removeItems.push(removeItem);
                        }

                    }
                }
            }
        }

        if (firstSelectorQuantity > 0) {
            handleCartChange(dataCode, firstSelectorQuantity, null, removeItems, bonusArray, event);
        }
    }

    function bonusItemHandler(isModified, quantity, selector) {

        var bonusItemsArray = [];
        var removeItemsArray = [];


        if (isModified) {
            //Add bonusItems
            if (selector.attr('data-match-alt') != null && selector.attr('data-match-alt').length > 0) {
                var tempBonusArray = selector.attr('data-match-alt').split(',');
                tempBonusArray.forEach(function (ele) {
                    bonusItemsArray.push({ Id: ele, Qty: quantity });
                });
            }

            //removebonusItems
            if (selector.attr('data-match') != null && selector.attr('data-match').length > 0) {
                var tempBonusArray = selector.attr('data-match').split(',');
                tempBonusArray.forEach(function (ele) {
                    removeItemsArray.push(ele);
                });
            }

            removeItemsArray.push(selector.attr('data-code'));
        }
        else {
            //Add bonusItems
            if (selector.attr('data-match') != null && selector.attr('data-match').length > 0) {
                var tempBonusArray = selector.attr('data-match').split(',');
                tempBonusArray.forEach(function (ele) {
                    bonusItemsArray.push({ Id: ele, Qty: quantity });
                });
            }

            //removebonusItems
            if (selector.attr('data-match-alt') != null && selector.attr('data-match-alt').length > 0) {
                var tempBonusArray = selector.attr('data-match-alt').split(',');
                tempBonusArray.forEach(function (ele) {
                    removeItemsArray.push(ele);
                });
            }

            if (selector.attr('data-code-alt') != null && selector.attr('data-code-alt').length > 0) {
                removeItemsArray.push(selector.attr('data-code-alt'));
            }
        }

        return {
            bonusItems: bonusItemsArray,
            removeItems: removeItemsArray
        };
    }

    function CreateModifierChangeAction(modifierArray) {

        if (modifierArray.length > 0) {

            modifierArray.forEach(function (ele) {

                var modifierName = ele;

                $(document).on('change', '[name=' + modifierName + '], #' + modifierName + '', function () {

                    var type = $(this).attr('type');

                    handleModifierChangeAction(modifierName, type);
                });

            });
        }
    }

    function getXorList(element) {

        var xor = $(element).attr('data-code-xor');
        var isDataCheckbox = $(element).attr('data-checkbox');
        isDataCheckbox = (typeof isDataCheckbox !== typeof undefined);
        var listItems = [];

        if (xor != null && xor.length > 0) {
            var allXORs = xor.split(',');
            for (var i = 0; i < allXORs.length; i++) {
                var singleXOR = allXORs[i];
                setToggleButton(singleXOR, 'Remove');
                listItems.push(singleXOR);
            };
        }

        if (isDataCheckbox) {
            checkboxToggleXor(listItems);
        }

        return listItems;
    }

    function dataMatchProductQuantity(mainItem, bonusItems, dataMatchTrue, event) {

        if (dataMatchTrue) {
            if ((typeof bonusItems != "undefined" && bonusItems != null && bonusItems.length > 0) && (typeof mainItem != "undefined" && mainItem != null && mainItem.length > 0)) {
                var datacode = mainItem;

                var bonusItems = bonusItems.split(',');
                var removeBonusItems = bonusItems.slice();


                var qty = $('[data-cart-code=' + datacode + 'Quantity]').children('[name^=ActionQuantity]').val();
                qty = parseInt(qty);

                if (!isNaN(qty)) {


                    if (qty > 0) {

                        var firstBonusItem = "";
                        var extraBonusItems = [];

                        for (var i = 0; i < bonusItems.length; i++) {

                            if (i == 0) {
                                firstBonusItem = bonusItems[i];
                            }
                            else {
                                extraBonusItems.push({ Id: bonusItems[i], Qty: qty });
                            }
                        }
                        if (firstBonusItem != "") {
                            handleCartChange(firstBonusItem, qty, null, [], extraBonusItems, event);
                        }
                    }
                    else {
                        handleCartChange(datacode, qty, null, removeBonusItems, null, event);
                    }
                }
            }

        }
        else {
            handleCartChange();
        }

    }

    function OnVSCookieLoaded() {
        $('input.zc').keyup(function () {
            updateZip(this.value, getState(), getCountry());
        });

        $('select.shipOptions').change(function () {
            handleCartChange();
        });

        $('#BillingZip, #ShippingZip').keyup(function () {

            var isShipCheckboxChecked = $('#ShippingIsDifferentThanBilling').is(':checked');

            if (this.id == 'ShippingZip') {
                lastChangeType = 'Shipping';
            } else {
                lastChangeType = '';
            }

            if (isShipCheckboxChecked) {
                $('.zc').val($('#ShippingZip').val());
                updateZip($('#ShippingZip').val(), getState(), getCountry());
            }
            else {
                $('.zc').val(this.value);
                updateZip(this.value, getState(), getCountry());
            }
        });

        $('#BillingState, #ShippingState, #BillingCountry, #ShippingCountry').keyup(function () {
            updateZip(getZip(), getState(), getCountry());
        });

        $("[name*='ActionToggle']").click(function () {
            var type = $(this).attr('data-toggle-type') || 'set';
            var toggleTargetIndex = $(this).attr('name').replace('ActionToggle', '');
            var toggleValue = $(this).attr('data-toggle-value') || '1';

            var actionCode = $('[name="ActionCode' + toggleTargetIndex + '"]') || [];
            var actionQuantity = $('[name="ActionQuantity' + toggleTargetIndex + '"]') || [];
            if (toggleTargetIndex == '' || actionCode.length == 0 || actionQuantity.length == 0) {
                console.error('Invalid ActionToggle configuration for ' + toggleTarget);
                return;
            }
            var currentValue = actionQuantity.val();

            if (type == 'add') {
                newValue = currentValue + 1;
            } else {
                if (currentValue == toggleValue) {
                    newValue = 0;
                } else {
                    newValue = toggleValue;
                }
            }
            actionQuantity.val(newValue);
            handleCartChange();
        });

        $('input[name*="ActionCode"][data-default]').each(function (i, item) {
            if ('radio,checkbox'.indexOf($(item).attr('type')) >= 0) {
                var id = $(item).attr('id');
                var name = $(item).attr('name');
                var index = id.replace('ActionCode', '');
                var value = $(item).val();

                var labelFor = $('label[for="' + id + '"]');
                if (labelFor.length > 0) {
                    labelFor.attr('for', 'Action' + index);
                } else {
                    labelFor = $('#ActionCode0').parents('label');
                    if (labelFor.length > 0) {
                        labelFor.attr('for', 'Action' + index);
                    }
                }

                $(this)
                    .attr('id', 'Action' + index)
                    .attr('name', 'Action' + index);
                $(this).before('<input id="' + id + '" name="' + name + '" type="hidden" value="' + value + '" data-default="' + $(item).attr('data-default') + '" data-upgrade="' + $(item).attr('data-upgrade') + '">')
            }
        });

        $('input[data-default]').click(function () {
            var index = ($(this).attr('id') || '').replace('Action', '');
            var currentValue = $(this).val();
            var defaultValue = $(this).attr('data-default');
            var toggleValue = $(this).attr('data-upgrade');
            var newValue;
            if ($(this).is(":checked")) {
                newValue = toggleValue;
            } else {
                newValue = defaultValue;
            }
            $(this).val(newValue);
            if ($('#ActionCode' + index).length > 0) {
                $('#ActionCode' + index).val(newValue);
                handleCartChange();
            } else {
                $('a[data-code="' + currentValue + '"]').attr('data-code', newValue);
                _dtmShoppingCart.UpgradeItem(currentValue, newValue);
            }
        });



        $("[name*='ActionQuantity']").each(function (i, item) {
            var index = (item.name || '').replace(/[^0-9]/g, '');
            if (_firstIndex == '') {
                _firstIndex = index;
            }
            $(item)
                .attr('data-index', index)
                .attr('class', ($(item).attr('class') ? $(item).attr('class') : '') + ' ddl')
                .change(handleCartChange);

            if ($('[name="ActionCode' + index + '"]').length == 0 || 'radio,checkbox'.indexOf($('[name="ActionCode' + index + '"]').attr('type')) >= 0 || $('[name="ActionCode' + index + '"]').is('select')) {
                $('[name="ActionCode' + index + '"]').change(handleCartChange);
            }
            if ($('[name="MatchProductQuantity' + index + '"]').length == 0 || 'radio,checkbox'.indexOf($('[name="MatchProductQuantity' + index + '"]').attr('type')) >= 0) {
                $('[name="MatchProductQuantity' + index + '"]').change(handleCartChange);
            }
        });

        <%if (enableEditableQuantity && !enableCustomCartMode)
    {%>
        var onDataCodesLoaded = function () {
            var modifiers = [];
            var dataMatchArray = [];

            registerEvent("ActionQuantityChange", function (e) {

                var actionCodeClicked = $('#ActionCode' + e.detail + '').val();
                if (dataMatchArray.length > 0) {
                    var mainItemArray = [];
                    $.each(dataMatchArray, function (idx, ele) {
                        mainItemArray.push(ele.mainItem);
                    });

                    //Check if ActionCode clicked is one of the main items in dataMatchArray , if not just call handleCartChange()
                    if (mainItemArray.indexOf(actionCodeClicked) > -1) {
                        $.each(dataMatchArray, function (idx, ele) {

                            var mainItem = ele.mainItem;
                            var bonusItems = ele.bonusItems;

                            if (actionCodeClicked == mainItem) {
                                //Register changeAction on main item ActionQuantity to inherit bonus
                                dataMatchProductQuantity(mainItem, bonusItems, bonusItems != "", e);
                            }

                        });
                    }
                    else {
                        handleCartChange();
                    }
                }
                else {
                    handleCartChange();
                }
            });
            $('[data-code-modifier]').each(function (i, item) {
                if (modifiers.indexOf($(item).attr('data-code-modifier')) < 0) {
                    modifiers.push($(item).attr('data-code-modifier'));
                }

            });

            for (var i = 0; i < modifiers.length; i++) {
                var modifier = modifiers[i];

                if ($('#' + modifier).length > 0) {
                    $(document).on('change', '#' + modifier, function (event) {
                        var mod = event.target.id;
                        var btns = $('[data-code][data-code-toggle=true][data-code-alt][data-code-modifier=' + mod + ']');
                        var sels = $('select[data-code-modifier=' + mod + ']');
                        var groupBtns = $('[data-group-name][data-code-modifier=' + mod + ']');
                        var isChecked = $('#' + mod).is(':checked');
                        var extraItems = [];
                        var removeItems = [];
                        var mainItem = '';
                        var mainQty = 0;

                        function setCartItemsForGroup(oldCodeSelector, newCodeSelector) {

                            var oldCode = isChecked ? oldCodeSelector : newCodeSelector;
                            var newCode = isChecked ? newCodeSelector : oldCodeSelector;
                            var regex = new RegExp("^" + oldCode + "$");
                            var cartItem = _dtmShoppingCart.SearchItems(regex);
                            var newQty = cartItem.length > 0 ? cartItem[oldCode].qty : 1;

                            if (cartItem.length > 0) {

                                if (mainItem == '' && mainQty == 0) {
                                    mainItem = newCode;
                                    mainQty = newQty;

                                }
                                else {
                                    extraItems.push({
                                        Id: newCode,
                                        Qty: newQty
                                    });
                                }
                                if (removeItems.indexOf(oldCode) < 0) {
                                    removeItems.push(oldCode);
                                }

                            }


                        }

                        groupBtns.each(function (idx, btn) {

                            var groupName = $(btn).attr('data-group-name');
                            var isCheckbox = $(btn).attr('data-checkbox') != null && $(btn).attr('data-checkbox').length > 0 ? $(btn).attr('data-checkbox') : null;

                            if (isCheckbox == "true") {

                                $('[name=' + groupName + ']:checked').each(function (idx, cbx) {



                                    var oldCodeSelector = $(cbx).val();
                                    var newCodeSelector = $(cbx).attr('data-code-alt');

                                    setCartItemsForGroup(oldCodeSelector, newCodeSelector);
                                });


                            }
                            else {

                                var oldCodeSelector = $('[name=' + groupName + ']:checked').val();
                                var newCodeSelector = $('[name=' + groupName + ']:checked').attr('data-code-alt');
                                setCartItemsForGroup(oldCodeSelector, newCodeSelector);
                            }

                        });

                        btns.each(function (idx, btn) {
                            var oldCode = isChecked ? $(btn).attr('data-code') : $(btn).attr('data-code-alt');
                            var newCode = isChecked ? $(btn).attr('data-code-alt') : $(btn).attr('data-code');
                            var newDataMatch = isChecked ? $(btn).attr('data-match-alt') : $(btn).attr('data-match');
                            var oldDataMatch = isChecked ? $(btn).attr('data-match') : $(btn).attr('data-match-alt');
                            var regex = new RegExp("^" + oldCode + "$");
                            var cartItem = _dtmShoppingCart.SearchItems(regex);
                            var newQty = cartItem.length > 0 ? cartItem[oldCode].qty : 1;

                            if (cartItem.length > 0) {
                                if (mainItem == '' && mainQty == 0) {
                                    mainItem = newCode;
                                    mainQty = newQty;

                                }
                                else {
                                    extraItems.push({
                                        Id: newCode,
                                        Qty: newQty
                                    });
                                }

                                if (removeItems.indexOf(oldCode) < 0) {
                                    removeItems.push(oldCode);
                                }

                                if (newDataMatch != null) {

                                    var bonusItems = newDataMatch.split(',');

                                    for (var i = 0; i < bonusItems.length; i++) {
                                        extraItems.push({
                                            Id: bonusItems[0],
                                            Qty: newQty
                                        });
                                    }

                                }
                                if (oldDataMatch != null) {

                                    if (oldDataMatch.length > 0) {
                                        var oldBonusItems = oldDataMatch.split(',');
                                        for (var i = 0; i < oldBonusItems.length; i++) {
                                            removeItems.push(oldBonusItems[i]);
                                        }

                                    }
                                }
                            }
                        });
                        sels.each(function (idx, sel) {
                            var selectedOption = $(sel).find(":selected");
                            var oldCode = isChecked ? $(selectedOption).attr('value') : $(selectedOption).attr('data-code-alt');
                            var newCode = isChecked ? $(selectedOption).attr('data-code-alt') : $(selectedOption).attr('value');
                            var regex = new RegExp("^(" + oldCode + ")$|^(" + newCode + ")$");
                            var cartItem = _dtmShoppingCart.SearchItems(regex);
                            var newQty = cartItem.length > 0 ? cartItem.TotalQuantity : 1;

                            if (cartItem.length > 0) {
                                if (mainItem == '' && mainQty == 0) {
                                    mainItem = newCode;
                                    mainQty = newQty;

                                }
                                else {
                                    extraItems.push({
                                        Id: newCode,
                                        Qty: newQty
                                    });
                                }

                                if (removeItems.indexOf(oldCode) < 0) {
                                    removeItems.push(oldCode);
                                }
                            }
                        });
                        if (mainItem != '') {
                            handleCartChange(mainItem, mainQty, null, removeItems, extraItems, event);
                        }
                    });

                }
            };

            $("[data-code]").each(function (i, item, event) {
                <%if (enableJumpToCartOnChange)
    {%>
                if (item.nodeName == 'A') {
                    $(item).attr('href', '#reviewOrder');
                }
                <%}
    else
    {%>
                if (item.nodeName == 'A') {
                    $(item).attr('href', 'javascript:void(0);');
                }
                <%}%>

                var selectId = $(this).attr('data-select-id');

                //Items with Select Dropdowns
                var isSelect = $(item).is('select');

                if (isSelect && typeof $(item).attr('data-select') !== 'undefined') {

                    var hasQtySelect = $(this).attr('data-qty-id');
                    var selectItem = $('#' + $(this).attr('id'));

                    if (hasQtySelect != null && hasQtySelect.length > 0) {
                        $('#' + hasQtySelect + '').change(function () {
                            selectItem.trigger('change');

                        });

                    }

                    var modifierId = $(item).attr('data-code-modifier');
                    if (typeof modifierId !== "undefined") {
                        //Change action for DataModifier with no AddToCart button
                        AddToModifierArray(modifierId);
                    }

                    $(item).unbind('change');
                    $(item).change(function () {
                        var datacode = $(this).val() == "0" ? "" : $(this).val();
                        var removeItems = [];
                        var selectedOption = $(item).find(":selected");
                        var overrideQty = (hasQtySelect != null && hasQtySelect.length > 0) ? parseInt($('#' + hasQtySelect + '').val()) : 1;
                        var isModified = isSelectorModified(item) && (selectedOption != null && selectedOption.length > 0) && ($(selectedOption).attr('data-code-alt') != null && $(selectedOption).attr('data-code-alt').length > 0);
                        var modifierName = ($(this).attr('data-code-modifier') != null && $(this).attr('data-code-modifier').length > 0) ? $(this).attr('data-code-modifier') : "";
                        var ifModifierRadio = modifierName != "" ? 'radio'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0 : false;
                        var preventAction = false;

                        if (ifModifierRadio) {
                            preventAction = !isModified && !$('[name=' + modifierName + ']').is(':checked') && (typeof $(this).attr('data-enforce-modifier') != "undefined");
                        }

                        datacode = isModified ? $(selectedOption).attr('data-code-alt') : datacode;

                        var selectItems = $(this).find('option[value != ""][value != "0"]').map(function () { return this.value }).get().join(",");
                        var altItems = $(this).find('option[value != ""][value != "0"][data-code-alt]').map(function () { return $(this).attr('data-code-alt'); }).get().join(",");

                        var sItems = selectItems + "," + altItems;

                        if (sItems != null && sItems.length > 0) {
                            var allItems = sItems.split(',');
                            for (var i = 0; i < allItems.length; i++) {
                                var singleItems = allItems[i];
                                removeItems.push(singleItems);
                            };
                        }

                        if (!preventAction) {
                            handleCartChange(datacode, overrideQty, null, removeItems, null, event);
                        }

                    });


                }

                //Toggle Button logic
                else {
                    var isRadioOrCB = 'radio,checkbox'.indexOf($(item).attr('type')) >= 0;

                    //PreSelected add-to-cart button on load
                    var isPreselected = $(item).attr('data-pre-selected') != null && $(item).attr('data-pre-selected').length > 0;

                    //Data Match used for bonus items                   
                    var dataMatch = ($(this).attr('data-match') != null && $(this).attr('data-match').length > 0) ? $(this).attr('data-match') : "";
                    var dataMatchAlt = $(this).attr('data-match-alt') != null && $(this).attr('data-match-alt').length > 0 ? $(this).attr('data-match-alt') : "";

                    var dataCode = $(this).attr('data-code');
                    var dataCodeAlt = $(this).attr('data-code-alt');

                    if (dataMatch != "") {
                        dataMatchArray.push({ mainItem: dataCode, bonusItems: dataMatch });
                    }
                    if (dataMatchAlt != "") {
                        dataMatchArray.push({ mainItem: dataCodeAlt, bonusItems: dataMatchAlt });
                    }

                    $(item).unbind('click');

                    //if Radio or Checkbox without toggle button , set State on load
                    if (isRadioOrCB) {
                        var datacode = ($(this).attr('data-code') != null && $(this).attr('data-code').length > 0) ? $(this).attr('data-code') : "";
                        var isModified = isSelectorModified(item);
                        datacode = isModified ? $(this).attr('data-code-alt') : datacode;
                        var hasQtySelect = $(this).attr('data-qty-id');
                        var overrideQty = (hasQtySelect != null && hasQtySelect.length > 0) ? parseInt($('#' + hasQtySelect + '').val()) : 1;
                        var bonusItems = isModified ? $(this).attr('data-match-alt') : $(this).attr('data-match');
                        var additionalItems = [];
                        var removeItems = [];
                        if (bonusItems != null && bonusItems.length > 0) {
                            var bonusItemArray = bonusItems.split(',');
                            for (var i = 0; i < bonusItemArray.length; i++) {

                                additionalItems.push({ Id: bonusItemArray[i], Qty: overrideQty });
                            }
                        }

                        if (datacode != "") {
                            if ($(this).is(':checked')) {
                                if ($(this).is(':radio')) {
                                    removeItems = $(this).attr('data-code-xor') != null ? $(this).attr('data-code-xor').split(',') : [];
                                }
                                handleCartChange(datacode, overrideQty, null, removeItems, additionalItems, event);
                            }
                        }

                        var hasModifier = $(item).attr('data-code-modifier') != null && $(item).attr('data-code-modifier').length > 0;

                        if (hasModifier) {

                            var modifierId = $(item).attr('data-code-modifier');
                            var groupName = $(this).attr('name');
                            var removeItems = [];

                            $('[name="' + groupName + '"]').each(function (i, groupItem) {
                                var tempdatacode = $(groupItem).attr('data-code');

                                if (hasModifier) {
                                    var alt = $(groupItem).attr('data-code-alt');
                                    removeItems.push(alt);
                                }

                                if (tempdatacode != null && tempdatacode.length > 0) {
                                    removeItems.push(tempdatacode);
                                }
                            });

                            //Change action for DataModifier with no AddToCart button
                            AddToModifierArray(modifierId);

                        }

                        if (hasQtySelect != null && hasQtySelect.length > 0) {

                            var selectQtyId = hasQtySelect;

                            $(document).on('change', '#' + selectQtyId, function () {

                                var isModified = isSelectorModified(item);
                                datacode = isModified ? $(item).attr('data-code-alt') : $(item).attr('data-code');
                                var active = isModified ? $('[data-code-alt=' + datacode + ']').is(':checked') : $('[data-code=' + datacode + ']').is(':checked');
                                var overrideQty = $(this).val();
                                var dataMatch = ($(item).attr('data-match') != null && $(item).attr('data-match').length > 0) ? $(item).attr('data-match') : "";
                                var dataMatchAlt = $(item).attr('data-match-alt') != null && $(item).attr('data-match-alt').length > 0 ? $(item).attr('data-match-alt') : "";
                                var dataMatchList = isModified ? dataMatchAlt : dataMatch;
                                var bonusArray = [];

                                if (dataMatchList.length > 0 && dataMatchList != null) {

                                    var bonusItems = dataMatchList.split(',');

                                    for (var i = 0; i < bonusItems.length; i++) {
                                        bonusArray.push({ Id: bonusItems[i], Qty: overrideQty });
                                    }
                                }
                                if (active) {

                                    handleCartChange(datacode, overrideQty, null, [], bonusArray, event);
                                }
                            });
                        }
                    }


                    if (isSelect && $(item).attr('data-select') == null) {
                        var hasModifier = $(item).attr('data-code-modifier') != null && $(item).attr('data-code-modifier').length > 0;
                        var renderItem = true;
                        var hasModifier = ($(this).attr('data-code-modifier') != null && $(this).attr('data-code-modifier').length > 0
                            && $(this).attr('data-code-alt') != null && $(this).attr('data-code-alt').length > 0);

                        if (hasModifier) {
                            var modifierName = $(this).attr('data-code-modifier');
                            var ifModifierCheckbox = 'checkbox'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0;
                            var ifModifierRadio = 'radio'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0;

                            if (ifModifierCheckbox) {
                                var isModified = $('[name=' + modifierName + ']').is(':checked');
                            }
                            if (ifModifierRadio) {
                                var isModified = $('[name=' + modifierName + ']:checked').val() == "true";
                                if (!$('[name=' + modifierName + ']').is(':checked')) {
                                    renderItem = false;
                                }
                            }

                            // 
                            AddToModifierArray(modifierName);

                        }
                        datacode = isModified ? $(item).attr('data-code-alt') : $(item).attr('data-code');
                        var qty = $(item).val();
                        var bonusItemArray = [];
                        if (dataMatchArray.length > 0) {

                            dataMatchArray.forEach(function (ele) {
                                if (datacode == ele.mainItem) {
                                    bonusItemArray.push({ Id: ele.bonusItems, Qty: qty });
                                }
                            });

                        }
                        //Add item on load
                        if (renderItem) {
                            var itemCart = getItems();
                            if (itemCart.length < 1) {
                                handleCartChange(datacode, qty, null, [], bonusItemArray, event);
                            }
                        }

                    }

                    var eventAction = isSelect ? "change" : "click";

                    $(item).bind(eventAction, function (event) {
                        var datacode = $(this).attr('data-code');
                        isRadioOrCB = 'radio,checkbox'.indexOf($(this).attr('type')) >= 0;
                        var inputGroupName = isRadioOrCB ? $(this).attr('name') : "";
                        var isToggleButton = $(this).attr('data-code-toggle') != null && $(this).attr('data-code-toggle').length > 0 && $(this).attr('data-code-toggle') == 'true';
                        var removeItems = [];
                        var isModified = isSelectorModified(item);
                        var modifierName = ($(this).attr('data-code-modifier') != null && $(this).attr('data-code-modifier').length > 0) ? $(this).attr('data-code-modifier') : "";
                        var ifModifierRadio = modifierName != "" ? 'radio'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0 : false;
                        var preventAction = false;
                        if (ifModifierRadio) {
                            preventAction = !isModified && !$('[name=' + modifierName + ']').is(':checked') && (typeof $(this).attr('data-enforce-modifier') != "undefined");
                        }

                        datacode = isModified ? $(this).attr('data-code-alt') : datacode;

                        $('[data-code-toggle=true]').addClass('disableToggleClick');

                        if (inputGroupName != null && inputGroupName.length > 0) {
                            $('[name="' + inputGroupName + '"]').each(function (i, groupItem) {
                                var tempdatacode = $(groupItem).attr('data-code');

                                if (isModified) {
                                    var alt = $(groupItem).attr('data-code-alt');
                                    removeItems.push(alt);
                                }

                                if (tempdatacode != null && tempdatacode.length > 0) {
                                    removeItems.push(tempdatacode);
                                }
                            });
                        }

                        if ($('[data-qty="' + datacode + '"]').length > 0) {
                            var overrideQty = $('[data-qty="' + datacode + '"]').val();
                            handleCartChange(datacode, overrideQty, null, removeItems, null, event);
                        }
                        else if (selectId != null && selectId.length > 0 && !isToggleButton) {

                            var regex = new RegExp("^" + datacode + "$");
                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                            var overrideQty = active ? 0 : $('#' + selectId).val();
                            handleCartChange(datacode, overrideQty, null, removeItems, null, event);
                        }
                        else if (isSelect && $(item).attr('data-select') == null) {
                            var overrideQty = $(this).val();
                            var renderItem = true;
                            var hasModifier = ($(this).attr('data-code-modifier') != null && $(this).attr('data-code-modifier').length > 0
                                && $(this).attr('data-code-alt') != null && $(this).attr('data-code-alt').length > 0);

                            if (hasModifier) {
                                var modifierName = $(this).attr('data-code-modifier');
                                var ifModifierCheckbox = 'checkbox'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0;
                                var ifModifierRadio = 'radio'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0;

                                if (ifModifierCheckbox) {
                                    var isModified = $('[name=' + modifierName + ']').is(':checked');
                                }
                                if (ifModifierRadio) {
                                    var isModified = $('[name=' + modifierName + ']:checked').val() == "true";
                                    if (!$('[name=' + modifierName + ']').is(':checked')) {
                                        renderItem = false;
                                    }
                                }

                            }

                            var removeItem = isModified ? $(this).attr('data-code') : $(this).attr('data-code-alt');
                            var bonusItemArray = [];
                            datacode = isModified ? $(this).attr('data-code-alt') : datacode;

                            if (dataMatchArray.length > 0) {

                                var datacodeSelected = isModified ? $(this).attr('data-code-alt') : datacode;
                                dataMatchArray.forEach(function (ele) {


                                    if (datacodeSelected == ele.mainItem) {
                                        var tempBonusItemArray = ele.bonusItems.split(',');

                                        tempBonusItemArray.forEach(function (bonusItem) {
                                            bonusItemArray.push({ Id: bonusItem, Qty: overrideQty });
                                        });

                                    }

                                });

                            }

                            removeItems.push(removeItem);

                            removeItems = removeItems.concat(getXorList(this));

                            if (renderItem) {
                                handleCartChange(datacode, overrideQty, null, removeItems, bonusItemArray, event);
                            }
                        }

                        else if (isToggleButton) {

                            var isModified = ($(this).attr('data-code-modifier') != null && $(this).attr('data-code-modifier').length > 0
                                && $(this).attr('data-code-alt') != null && $(this).attr('data-code-alt').length > 0
                                && $('#' + $(this).attr('data-code-modifier')).is(':checked'));
                            datacode = isModified ? $(this).attr('data-code-alt') : datacode;

                            var regex = new RegExp("^" + datacode + "$");
                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                            var overrideQty = active ? 0 : 1;
                            if (selectId != null && selectId.length > 0) {

                                if (datacode.indexOf(',') > -1 && selectId.indexOf(',') > -1) {

                                    var allDataCodes = datacode.split(',');
                                    var allSelectIds = selectId.split(',');
                                    var allDataCodesRegex = datacode.replace(',', ')$|^(');
                                    var selectRegex = new RegExp("^(" + allDataCodesRegex + ")$");
                                    active = _dtmShoppingCart.SearchItems(selectRegex).length > 0;
                                    var additionalItems = [];
                                    for (var i = 0; i < allSelectIds.length; i++) {

                                        var singleSelect = allSelectIds[i];
                                        var singleDataCode = allDataCodes[i];
                                        var quantity = active ? 0 : $('#' + singleSelect).val();
                                        if (i == 0) {
                                            datacode = singleDataCode;

                                            overrideQty = quantity;
                                        }
                                        else {
                                            additionalItems.push({ Id: singleDataCode, Qty: quantity });
                                        }

                                    }

                                }
                                else {
                                    overrideQty = active ? 0 : $('#' + selectId).val();
                                }
                            }

                            removeItems = getXorList(this);

                            //Adding bonus item quantities to additionalItems array
                            var bonusItemList = isModified ? dataMatchAlt : dataMatch;
                            if (bonusItemList.length > 0 && bonusItemList != null) {

                                var bonusItems = bonusItemList.split(',');
                                var bonusArray = [];
                                for (var i = 0; i < bonusItems.length; i++) {

                                    bonusArray.push({ Id: bonusItems[i], Qty: overrideQty });
                                }

                                if (typeof additionalItems !== 'undefined' && additionalItems.length > 0) {

                                    additionalItems.concat(bonusArray);

                                }
                                else {
                                    var additionalItems = bonusArray.slice();
                                }
                            }

                            handleCartChange(datacode, overrideQty, null, removeItems, additionalItems, event);
                        }
                        else {
                            if (isRadioOrCB) {

                                var hasQtySelect = $(this).attr('data-qty-id');
                                var overrideQty = (hasQtySelect != null && hasQtySelect.length > 0) ? parseInt($('#' + hasQtySelect + '').val()) : 1;
                                var bonusItemObject = bonusItemHandler(isModified, overrideQty, $(this));
                                removeItems = removeItems.concat(bonusItemObject["removeItems"]);
                                if ($(this).is(':checked') && !preventAction) {


                                    removeItems = removeItems.concat(getXorList(this));

                                    if ($(this).attr('data-checkbox') != null && $(this).attr('data-checkbox').length > 0) {
                                        var tempRemoveCodeArray = getXorList(this);
                                        $.each(tempRemoveCodeArray, function (idx, ele) {
                                            $('[data-code=' + ele + '],[data-code-alt=' + ele + ']').prop('checked', false);
                                        });
                                    }

                                    //Adding bonus item quantities to additionalItems array
                                    var additionalItems = bonusItemObject["bonusItems"];


                                    handleCartChange(datacode, overrideQty, null, removeItems, additionalItems, event);
                                }
                                else {
                                    if (typeof bonusItemObject["bonusItems"] != "undefined") {
                                        $.each(bonusItemObject["bonusItems"], function (idx, ele) {
                                            removeItems.push(ele.Id);
                                        });
                                    }
                                    handleCartChange(datacode, 0, null, removeItems, null, event);
                                }
                            }
                            else {
                                handleCartChange(datacode, null, null, removeItems, null, event);
                            }
                        }
                        if (typeof onItemClick == "function") {
                            onItemClick(this, event);
                        }
                    });

                }
                if (selectId != null && selectId.length > 0) {
                    var datacode = $(item).attr('data-code');

                    if (datacode.indexOf(',') > -1 && selectId.indexOf(',') > -1) {

                        var allDataCodes = datacode.split(',');
                        var allSelectIds = selectId.split(',');
                        var dataCodeRegex = datacode.replace(',', ')$|^(');

                        $.each(allSelectIds, function (index, id) {

                            $(document).on('change', '#' + id, function () {



                                datacode = allDataCodes[index];
                                var regex = new RegExp("^(" + dataCodeRegex + ")$");
                                var active = _dtmShoppingCart.SearchItems(regex).length > 0;

                                if (active) {


                                    var overrideQty = $(this).val();

                                    var additionalItems = [];
                                    for (var i = 0; i < allSelectIds.length; i++) {
                                        var singleSelect = allSelectIds[i];
                                        if (id != singleSelect) {
                                            var singleDataCode = allDataCodes[i];
                                            var quantity = $('#' + singleSelect).val();
                                            additionalItems.push({ Id: singleDataCode, Qty: quantity });
                                        }
                                    }
                                    setToggleButton(datacode, 'Update');
                                    handleCartChange(datacode, overrideQty, null, [], additionalItems, event);
                                }
                            });
                        });
                    }
                    else {
                        $(document).on('change', '#' + selectId, function () {

                            var isModified = ($(item).attr('data-code-modifier') != null && $(item).attr('data-code-modifier').length > 0
                                && $(item).attr('data-code-alt') != null && $(item).attr('data-code-alt').length > 0
                                && $('#' + $(item).attr('data-code-modifier')).is(':checked'));
                            datacode = isModified ? $(item).attr('data-code-alt') : datacode;
                            var regex = new RegExp("^" + datacode + "$");
                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                            var overrideQty = $(this).val();
                            var dataMatch = ($(item).attr('data-match') != null && $(item).attr('data-match').length > 0) ? $(item).attr('data-match') : "";
                            var dataMatchAlt = $(item).attr('data-match-alt') != null && $(item).attr('data-match-alt').length > 0 ? $(item).attr('data-match-alt') : "";
                            var dataMatchList = isModified ? dataMatchAlt : dataMatch;
                            var bonusArray = [];

                            if (dataMatchList.length > 0 && dataMatchList != null) {

                                var bonusItems = dataMatchList.split(',');

                                for (var i = 0; i < bonusItems.length; i++) {
                                    bonusArray.push({ Id: bonusItems[i], Qty: overrideQty });
                                }
                            }
                            if (active) {

                                setToggleButton(datacode, 'Update');
                                handleCartChange(datacode, overrideQty, null, [], bonusArray, event);
                            }
                        });
                    }
                }

                if (isPreselected) {
                    var isModified = ($(item).attr('data-code-modifier') != null && $(item).attr('data-code-modifier').length > 0
                        && $(item).attr('data-code-alt') != null && $(item).attr('data-code-alt').length > 0
                        && $('#' + $(item).attr('data-code-modifier')).is(':checked'));
                    var dataMatch = ($(this).attr('data-match') != null && $(this).attr('data-match').length > 0) ? $(this).attr('data-match') : "";
                    var dataMatchAlt = $(this).attr('data-match-alt') != null && $(this).attr('data-match-alt').length > 0 ? $(this).attr('data-match-alt') : "";
                    var dataMatchList = isModified ? dataMatchAlt : dataMatch;
                    var datacode = isModified ? $(item).attr('data-code-alt') : $(item).attr('data-code');
                    var bonusArray = [];

                    if (dataMatchList.length > 0 && dataMatchList != null) {

                        var bonusItems = dataMatchList.split(',');

                        for (var i = 0; i < bonusItems.length; i++) {

                            bonusArray.push({ Id: bonusItems[i], Qty: 1 });
                        }
                    }

                    var itemCart = getItems();
                    if (itemCart.length < 1) {
                        handleCartChange(datacode, null, null, [], bonusArray, event);
                    }
                }
            });

            $("[data-group-name][data-code-toggle=true]").each(function (i, item) {
                var groupName = $(this).attr('data-group-name');
                var isDataSelect = $(this).attr('data-select');
                var isDataCheckbox = $(this).attr('data-checkbox');
                var hasQtySelect = $(this).attr('data-qty-id');
                isDataSelect = (typeof isDataSelect !== typeof undefined);
                isDataCheckbox = (typeof isDataCheckbox !== typeof undefined);



                var overrideQty = 1;
                var removeItems = [];
                var dcSelector = isDataSelect ? ('[name="' + groupName + '"] option[value != ""]') : ('[name="' + groupName + '"]');


                if (isDataSelect) {

                    var selectName = $('[name=' + groupName + ']');
                    selectName.unbind('change');
                    var isDataSelectGroup = $(selectName).attr('data-select-group');
                    isDataSelectGroup = (typeof isDataSelectGroup !== typeof undefined);

                    if (typeof hasQtySelect !== typeof undefined) {
                        $('#' + hasQtySelect + '').change(function () {
                            selectName.trigger('change');

                        })

                    }

                    if (isDataSelectGroup) {
                        selectName.change(function () {
                            var gName = $(this).attr("name");
                            var selectRemove = [];
                            var groupItems = $('[name="' + gName + '"]').find('option[value != ""]').map(function () { return this.value }).get().join(")$|^(");
                            var selectItems = $(this).find('option[value != ""]').map(function () { return this.value }).get().join(",");
                            var newSelectedItem = $(this).val();
                            var regex = new RegExp("^(" + groupItems + ")$");

                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;

                            if (active) {

                                var sItems = selectItems;
                                if (sItems != null && sItems.length > 0) {
                                    var allItems = sItems.split(',');
                                    for (var i = 0; i < allItems.length; i++) {
                                        var singleItems = allItems[i];
                                        selectRemove.push(singleItems);
                                    };
                                }
                                handleCartChange(newSelectedItem, overrideQty, null, selectRemove, null, event);
                            }



                        });

                    }
                    else {
                        selectName.change(function () {
                            var dataCode = $(this).val();
                            var selectItems = $(this).find('option[value != ""]').map(function () { return this.value }).get().join(",");
                            var dataCodes = $(dcSelector)
                                .map(function () { return this.value; })
                                .get().join(')$|^(');
                            var regex = new RegExp("^(" + dataCodes + ")$");
                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                            overrideQty = (hasQtySelect != null && hasQtySelect.length > 0) ? parseInt($('#' + hasQtySelect + '').val()) : 1;
                            if (active) {
                                var sItems = selectItems;
                                if (sItems != null && sItems.length > 0) {
                                    var allItems = sItems.split(',');
                                    for (var i = 0; i < allItems.length; i++) {
                                        var singleItems = allItems[i];
                                        removeItems.push(singleItems);
                                    };
                                }

                                handleCartChange(dataCode, overrideQty, null, removeItems, null, event);
                            }
                        });
                    }

                }
                else if (isDataCheckbox) {
                    var hasDataMatch = $('input[type=checkbox][name=' + groupName + '][data-match]').length > 0;
                    if (hasDataMatch) {
                        $('input[type=checkbox][name=' + groupName + '][data-match]').each(function (idx, ele) {
                            var dataMatch = $(this).attr('data-match');
                            var dataCode = $(this).val();
                            dataMatchArray.push({ mainItem: dataCode, bonusItems: dataMatch });

                            dataMatch = $(this).attr('data-match-alt');
                            if (typeof dataMatch != "undefined" && dataMatch.length > 0) {
                                dataMatch = $(this).attr('data-code-alt');
                                dataMatchArray.push({ mainItem: dataCode, bonusItems: dataMatch });
                            }

                        });
                    }

                    $(document).on('change', 'input[type=checkbox][name=' + groupName + ']', function (event) {

                        var group = '[name = ' + groupName + ']';

                        var isModified = ($(group).attr('data-code-modifier') != null && $(group).attr('data-code-modifier').length > 0
                            && $(group).attr('data-code-alt') != null && $(group).attr('data-code-alt').length > 0
                            && $('#' + $(group).attr('data-code-modifier')).is(':checked'));

                        var modifier = isModified ? $('[name = ' + groupName + ']').attr('data-code-modifier') : null;
                        var removeItems = [];
                        var newItems = [];
                        var dataCodes = $('[name=' + groupName + ']')
                            .map(function () { return this.value; })
                            .get().join(')$|^(');

                        if (isModified) {
                            if ($('#' + modifier).is(':checked')) {
                                dataCodes = $('[name=' + groupName + ']')
                                    .map(function () { return $(this).attr('data-code-alt'); })
                                    .get().join(')$|^(');
                            }
                        }

                        var regex = new RegExp("^(" + dataCodes + ")$");
                        var active = _dtmShoppingCart.SearchItems(regex).length > 0;

                        if (active) {
                            $('[data-code-toggle]').addClass('disableToggleClick');
                            $('[name="' + groupName + '"]').each(function (i, groupItem) {
                                var modifier = ($(groupItem).attr('data-code-modifier') != null && $(groupItem).attr('data-code-modifier').length > 0) ? $(groupItem).attr('data-code-modifier') : null;
                                var isModified = modifier != null ? $('#' + modifier + '').is(':checked') : false;
                                var dataMatch = isModified ? $(groupItem).attr('data-match-alt') : $(groupItem).attr('data-match');
                                var tempdatacode = isModified ? $(groupItem).attr('data-code-alt') : $(groupItem).val();

                                var selected = $(groupItem).is(':checked');
                                if (tempdatacode != null && tempdatacode.length > 0) {
                                    if (selected) {
                                        var item = {
                                            Id: tempdatacode,
                                            Qty: 1
                                        }

                                        newItems.push(item);

                                        if (dataMatch != null && dataMatch.length > 0) {
                                            var bonusItems = dataMatch.split(',');
                                            for (var i = 0; i < bonusItems.length; i++) {
                                                newItems.push({ Id: bonusItems[i], Qty: 1 });
                                            }
                                        }
                                    }
                                    else {
                                        removeItems.push(tempdatacode);

                                        if (dataMatch != null && dataMatch.length > 0) {
                                            var bonusItems = dataMatch.split(',');
                                            for (var i = 0; i < bonusItems.length; i++) {
                                                removeItems.push(bonusItems[i]);
                                            }
                                        }
                                    }
                                }
                            });

                            setToggleButton(groupName, 'Update');
                            if (newItems.length > 0) {
                                handleCartChange("", 0, null, removeItems, newItems, event);
                            } else {
                                handleCartChange("", 0, null, removeItems, null, event);
                            }

                        }
                    });
                }
                else {
                    if (hasQtySelect) {
                        var qtySelectId = $(this).attr('data-qty-id');
                        $(document).on('change', 'select[id=' + qtySelectId + ']', function (event) {
                            $('input[type=radio][name=' + groupName + ']').trigger('change');
                        });

                    }

                    //add radio Bonus items to dataMatchArray for ActionQuantityChange link
                    var hasDataMatch = $('input[type=radio][name=' + groupName + '][data-match]').length > 0;
                    if (hasDataMatch) {
                        $('input[type=radio][name=' + groupName + '][data-match]').each(function (idx, ele) {
                            var dataMatch = $(this).attr('data-match');
                            var dataCode = $(this).val();
                            dataMatchArray.push({ mainItem: dataCode, bonusItems: dataMatch });

                            dataMatch = $(this).attr('data-match-alt');
                            if (typeof dataMatch != "undefined" && dataMatch.length > 0) {
                                dataMatch = $(this).attr('data-code-alt');
                                dataMatchArray.push({ mainItem: dataCode, bonusItems: dataMatch });
                            }

                        });
                    }


                    $(document).on('change', 'input[type=radio][name=' + groupName + ']', function (event) {

                        var hasModifier = $('[name = ' + groupName + ']').attr('data-code-alt') != null && $('[name = ' + groupName + ']').attr('data-code-alt').length > 0;
                        var isModified = false;
                        var altCodes = "";
                        var dataCodes = $('[name="' + groupName + '"]')
                            .map(function () { return this.value; })
                            .get().join(')$|^(');


                        var regex = new RegExp("^(" + dataCodes + ")$");

                        if (hasModifier) {

                            var modifier = $('[data-group-name = ' + groupName + ']').attr('data-code-modifier');
                            isModified = $('#' + modifier + '').is(':checked');

                            altCodes = $('[name="' + groupName + '"]')
                                .map(function () { return $(this).attr('data-code-alt'); })
                                .get().join(')$|^(');

                            regex = new RegExp("^(" + dataCodes + ")$|^(" + altCodes + ")$");

                        }

                        var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                        var qty = getToggleButtonQty(groupName, 1);

                        if (active) {
                            var newCodes = [];
                            var removeItems = [];
                            var newCode = isModified ? $(this).attr('data-code-alt') : $(this).val();

                            $('[data-code-toggle]').addClass('disableToggleClick');
                            $('[name="' + groupName + '"]').each(function (i, groupItem) {

                                var tempdatacode = isModified ? $(groupItem).attr('data-code-alt') : $(groupItem).val();
                                var dataMatch = isModified ? $(groupItem).attr('data-match-alt') : $(groupItem).attr('data-match');

                                var selected = $(groupItem).is(':checked');
                                if (tempdatacode != null && tempdatacode.length > 0) {
                                    if (selected) {
                                        newCode = tempdatacode;
                                        if (dataMatch != null && dataMatch.length > 0) {
                                            var bonusItems = dataMatch.split(',');
                                            for (var i = 0; i < bonusItems.length; i++) {
                                                newCodes.push({ Id: bonusItems[i], Qty: qty });
                                            }
                                        }
                                    }
                                    else {
                                        removeItems.push(tempdatacode);
                                        if (dataMatch != null && dataMatch.length > 0) {
                                            var bonusItems = dataMatch.split(',');
                                            for (var i = 0; i < bonusItems.length; i++) {
                                                removeItems.push(bonusItems[i]);
                                            }

                                        }
                                    }
                                }
                            });

                            setToggleButton(groupName, 'Update');
                            handleCartChange(newCode, qty, null, removeItems, newCodes, event);
                        }
                    });
                }

                $(item).click(function (event) {
                    var removeItems = [];

                    var hasModifier = $('[name = ' + groupName + ']').attr('data-code-alt') != null && $('[name = ' + groupName + ']').attr('data-code-alt').length > 0;
                    var isModified = false;
                    var altCodes = "";
                    var dataCodes = $(dcSelector)
                        .map(function () { return this.value; })
                        .get().join(')$|^(');

                    var regex = new RegExp("^(" + dataCodes + ")$");

                    if (hasModifier) {
                        var modifier = hasModifier ? $('[data-group-name = ' + groupName + ']').attr('data-code-modifier') : null;
                        isModified = $('#' + modifier + '').is(':checked');

                        altCodes = $(dcSelector)
                            .map(function () { return $(this).attr('data-code-alt'); })
                            .get().join(')$|^(');

                        regex = new RegExp("^(" + dataCodes + ")$|^(" + altCodes + ")$");
                    }

                    var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                    var newCode = '';
                    var newQty = active ? 0 : 1;
                    var newCodes = [];
                    newQty = getToggleButtonQty(groupName, newQty);
                    $('[data-code-toggle=true]').addClass('disableToggleClick');

                    $('[name="' + groupName + '"]').each(function (i, groupItem) {
                        var tempdatacode = isModified ? $(groupItem).attr('data-code-alt') : $(groupItem).val();
                        var dataMatch = isModified ? $(groupItem).attr('data-match-alt') : $(groupItem).attr('data-match');
                        if (!isDataSelect) {
                            var selected = $(groupItem).is(':checked');
                        }
                        if (tempdatacode != null && tempdatacode.length > 0) {
                            if ((!isDataSelect && selected) || isDataSelect) {
                                newCode = tempdatacode;
                                newCodes.push({ Id: tempdatacode, Qty: newQty });
                                if (dataMatch != null && dataMatch.length > 0) {
                                    var bonusItems = dataMatch.split(',');
                                    for (var i = 0; i < bonusItems.length; i++) {
                                        newCodes.push({ Id: bonusItems[i], Qty: newQty });
                                    }
                                }
                            }
                            else {
                                removeItems.push(tempdatacode);

                                if (dataMatch != null && dataMatch.length > 0) {
                                    var bonusItems = dataMatch.split(',');
                                    for (var i = 0; i < bonusItems.length; i++) {
                                        removeItems.push(bonusItems[i]);
                                    }
                                }

                            }
                        }


                    });

                    if (isDataCheckbox) {

                        var removeItemCheckboxes = [];

                        for (var i = 0; i < newCodes.length; i++) {

                            if (newCodes[i].Qty < 1) {
                                removeItemCheckboxes.push(newCodes[i].Id);
                            }
                        }
                        checkboxToggleXor(removeItemCheckboxes);
                    }

                    removeItems = removeItems.concat(getXorList(this));

                    handleCartChange(newCode, newQty, null, removeItems, newCodes, event);
                    //for (var i = 0; i < newCodes.length; i++) {
                    //    //var c = newCodes[i];
                    //    handleCartChange(c, newQty, null, removeItems, newCodes, event);
                    //}
                });
            });

        };

        loadAllItemStates();
        onDataCodesLoaded();
        CreateModifierChangeAction(modifierArray);
        registerEvent("DataCodesLoaded", onDataCodesLoaded);
        <%}
    else
    { %>
        loadAllItemStates();
        <%} %>


        <%if (showPromoCodeButton)
    { %>
        // check if the promo code button exists
        if ($('.ddlPromoButton').length > 0) {
            // append the handle cart change functionality to the button
            $('.ddlPromoButton').attr({ 'onclick': '_firstRun = false; handleCartChange();' });
            $('.ddlPromoButton').on('keyup keypress', function (e) {
                var keyCode = e.keyCode || e.which;
                if (keyCode === 13) {
                    e.preventDefault();
                    return false;
                }
            });
        } else {
            // otherwise, create the button and append it to the promo field
            $('.ddlPromo').after("<input type='button' class='ddlPromoButton' onclick='_firstRun = false; handleCartChange();' value='Apply Code' />");
        }
        <%}
    else
    {%>
        $('.ddlPromo').change(function () {
            handleCartChange();
        });
        <% } %>

        $("#ShippingIsDifferentThanBilling").on("click", function () {
            var selector = $('#ShippingIsDifferentThanBilling').is(':checked') ? '#ShippingZip' : '#BillingZip';
            var zip = $(selector).val() != undefined ? $(selector).val() : '';

            updateZip(zip, getState(), getCountry());
            handleCartChange();
        });

        $('[name^="ActionAttribute"]').change(function () {
            var index = ($(this).attr('name') || '').replace('ActionAttribute', '');
            var allValues = new Array();
            $.each($('[name="ActionAttribute' + index + '"]'), function () {
                allValues.push($(this).val());
            });
            if ($('[name^="ActionAttribute' + index + '"]').length == allValues.length) {
                handleCartChange();
            }
        });
    }
    function getToggleButtonQty(groupName, defaultValue) {
        var qty = defaultValue;
        var toggleButton = $("[data-group-name='" + groupName + "'][data-code-toggle=true][data-qty-id]");
        if ($(toggleButton).length > 0) {
            var hasQtyId = $(toggleButton).attr("data-qty-id").length > 0;
            var overrideQty = qty;
            if (hasQtyId) {
                var qtyId = $(toggleButton).attr("data-qty-id");
                overrideQty = $("#" + qtyId).val();
            }
            qty = overrideQty;
        }
        if (defaultValue == 0) {
            qty = 0;
        }
        return qty;
    }

    function setToggleButtonQty(groupName, value) {
        var toggleButton = $("[data-group-name='" + groupName + "'][data-code-toggle=true][data-qty-id]");
        if ($(toggleButton).length > 0) {
            var hasQtyId = $(toggleButton).attr("data-qty-id").length > 0;
            if (hasQtyId) {
                var qtyId = $(toggleButton).attr("data-qty-id");
                $("#" + qtyId).val(value);
            }
        }
    }
    function loadItemState(productCode, qty) {
        var getEle = function (pc) {
            var ret = null;

            if ($('[name*=ActionCode][value="' + productCode + '"]').length != 0) {
                ret = $('[name*=ActionCode][value="' + productCode + '"]');
            }
            else if ($('[name*=ActionCode][data-default="' + productCode + '"]').length != 0) {
                ret = $('[name*=ActionCode][data-default="' + productCode + '"]');
            }
            else if ($('[name*=ActionCode][data-upgrade="' + productCode + '"]').length != 0) {
                ret = $('[name*=ActionCode][data-upgrade="' + productCode + '"]');
            }
            else if ($('[name*=ActionCheckbox][data-target="' + productCode + '"]').length != 0) {
                ret = $('[name*=ActionCheckbox][data-target="' + productCode + '"]');
            }
            else if ($('[name*=ActionCheckbox][data-new="' + productCode + '"]').length != 0) {
                ret = $('[name*=ActionCheckbox][data-new="' + productCode + '"]');
            }
            return ret;
        }

        var ele = getEle(productCode);
        var index = ($(ele).attr('name') || '').replace('ActionCode', '');
        var id = productCode;
        var originalId = id;
        var isMod = false;

        var modEle = $('[data-code][data-code-toggle=true][data-code-alt=' + id + '][data-code-modifier]');
        if (modEle.length == 0) {
            modEle = $('select[data-code-modifier] option[data-code-alt=' + id + '], select[data-code-modifier] option[value=' + id + ']');
            if (modEle.length > 0) {
                modEle = $(modEle).parent();
            }
        }

        if (modEle.length > 0 && $('#' + modEle.attr('data-code-modifier')).length > 0) {
            $('#' + modEle.attr('data-code-modifier')).prop('checked', true);
            if (modEle.attr('data-code').length > 0) {
                originalId = modEle.attr('data-code');
            }
            else {
                originalId = $('select[data-code-modifier] option[data-code-alt=' + id + ']').attr('value');
                isMod = true;
                if (originalId == null) {
                    originalId = $('select[data-code-modifier] option[value=' + id + ']').attr('value');
                    isMod = false;
                }
                var cbox = $('#' + $(modEle).attr('data-code-modifier'));
                if (isMod) {
                    $(cbox).attr('checked', true);
                }
                else {
                    $(cbox).attr('checked', false);
                }

            }

            if (originalId == '') {
                originalId = id;
            }
        }

        var selEle = $('select[data-code-modifier] option[data-code-alt=' + id + '], select[data-code-modifier] option[value=' + id + ']');
        if (selEle.length > 0) {
            $(modEle).val(originalId);

            if (typeof $(modEle).attr('data-qty-id') !== "undefined") {
                var selectableEle = $('#' + $(modEle).attr('data-qty-id'));
                $(selectableEle).val(qty);
            }
        }

        var actionEle = $('[name*=ActionCode] option[value="' + id + '"]');
        if (actionEle.length != 0) {
            actionEle.parent().val(id);
        }

        if (ele == null) {
            console.log("No matching elements, item state not loaded for " + id);
            return;
        }
        else if (ele.length > 1) {
            console.log("Too many matching elements, item state not loaded for " + id);
            return;
        }

        var preventCheck = false, preventClick = false;
        if (ele.attr('data-default') == id) {
            if ($('#ActionQuantity' + index).length != 0) {
                $('#ActionQuantity' + index).val(qty);
                preventClick = true;
                preventCheck = true;
            }
        } else if (ele.attr('data-upgrade') == id) {
            ele.val(id);

            if ($('#ActionQuantity' + index).length != 0) {
                $('#ActionQuantity' + index).val(qty);
                preventClick = true;
            }
        } else if (ele.attr('name').indexOf("ActionCheckbox") >= 0) {

            index = ($(ele).attr('name') || '').replace('ActionCheckbox', '');

            if (ele.data('new') == id) {
                ele.prop('checked', true);
            }
            if (ele.data('target') == id) {
                ele.prop('checked', false);
                if ($('#ActionCode' + index).val() != ele.data('target')) {
                    $('#ActionCode' + index).val(ele.data('target'));
                }
            }

            if ($('#ActionQuantity' + index).length != 0) {
                $('#ActionQuantity' + index).val(qty);
                preventClick = true;
            }
        } else if (ele.attr('type') == 'checkbox') {
            ele.prop('checked', true);
        }


        var checkableEle = null;
        var action = $('#Action' + index);


        // Action
        if ($(action).length > 0 && $('[name="Action' + index + '"]').length == 0 || 'radio,checkbox'.indexOf(action.attr('type')) >= 0) {
            action.val(id);
            checkableEle = action;
        }

        else {
            var radioWithModifier = $('input[type=radio][data-code-modifier][data-code-alt=' + id + ']');
            var checkboxWithModifier = $('input[type=checkbox][data-code-modifier][data-code-alt=' + id + ']');
            var radioFromGroup = $('input[type=radio][value=' + id + ']');
            var radioSolo = $('input[type=radio][data-code=' + id + ']');
            var selectFromGroup = $('select option[value= ' + id + ']').parent();
            var checkboxGroup = $('input[type=checkbox][value=' + id + ']');
            var singleCheckbox = $('input[type=checkbox][data-code=' + id + '], input[type=checkbox][data-code-alt=' + id + '] ');
            var isSingleCheckbox = singleCheckbox.length > 0;
            var isRadioWithModifier = $(radioWithModifier).length > 0;
            var isCheckboxWithModifier = $(checkboxWithModifier).length > 0;
            var isRadioSelect = $(radioFromGroup).length > 0 && $('[data-group-name=' + $(radioFromGroup).attr('name') + '][data-code-toggle=true]').length > 0;
            var isRegularSelect = $(selectFromGroup).length > 0 && $('[data-group-name=' + $(selectFromGroup).attr('name') + '][data-code-toggle=true]').length > 0;
            var isCheckboxSelect = $(checkboxGroup).length > 0 && $('[data-group-name=' + $(checkboxGroup).attr('name') + '][data-code-toggle=true]').length > 0;
            var isRadioSolo = $(radioSolo).length > 0;
            var isDataCodeSelect = $('select[data-code=' + id + '], select[data-code-alt=' + id + '] ').length > 0;


            var selectItem = radioFromGroup;
            //Toggle Button + Data Group + Check/Selectable Item
            if (isRegularSelect || isRadioSelect || isCheckboxSelect) {
                if (isRegularSelect) {
                    selectItem = selectFromGroup;
                    selectFromGroup.val(id);
                }
                else if (isRadioSelect) {
                    checkableEle = radioFromGroup;
                }
                else if (isCheckboxSelect) {
                    selectItem = checkboxGroup;
                    checkboxGroup.prop("checked", true);
                }

                var groupName = $(selectItem).attr('name');
                var toggleButton = $('[data-group-name=' + $(selectItem).attr('name') + '][data-code-toggle=true]');

                if ($(toggleButton).length > 0) {
                    registerEvent("ToggleButtonInitialized", function () {
                        setToggleButton(groupName, 'Add');
                    });
                }
            }

            //Select w/ Data-code + qty
            if (isDataCodeSelect) {
                var selector = $('select[data-code=' + id + '], select[data-code-alt=' + id + '] ');
                selector.val(qty);

                var hasModifier = selector.attr('data-code-modifier') != null;

                if (hasModifier) {
                    var modifierName = selector.attr('data-code-modifier');
                    var ifModifierCheckbox = 'checkbox'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0;
                    var ifModifierRadio = 'radio'.indexOf($('[name=' + modifierName + ']').attr('type')) >= 0;
                    var modifierSelected = $('select[data-code-alt=' + id + '] ');

                    if (modifierSelected.length > 0) {

                        if (ifModifierCheckbox) {
                            $('[name=' + modifierName + ']').attr('checked', true);
                        }
                        else if (ifModifierRadio) {
                            $('[name=' + modifierName + '][value="true"]').attr('checked', true);
                        }
                    }
                    else {
                        if (ifModifierRadio) {
                            $('[name=' + modifierName + '][value=false]').attr('checked', true);
                        } else if (ifModifierCheckbox) {
                            $('[name=' + modifierName + ']').attr('checked', false);
                        }
                    }
                }

            }

            //Radio w/ Data-code only
            else if (isRadioSolo) {
                checkableEle = radioSolo;

                //Radio w/ Radio-Modifier , setting False Radio
                if (radioSolo.attr('data-code-modifier') != null && radioSolo.attr('data-code-modifier').length > 1) {
                    var modifierName = radioSolo.attr('data-code-modifier');
                    if ($('input[type=radio][name=' + modifierName + '][value=false]').length > 0) {
                        $('input[type=radio][name=' + modifierName + '][value=false]').prop('checked', true);
                    }
                }
            }

            //Radio w/ Data-code and Data-Code-Modifier only (Alt code is selected) 
            else if (isRadioWithModifier) {
                var modId = radioWithModifier.attr('data-code-modifier');
                checkableEle = radioWithModifier;
                var ifModifierCheckbox = 'checkbox'.indexOf($('[name=' + modId + '],[id=' + modId + ']').attr('type')) >= 0;
                var ifModifierRadio = 'radio'.indexOf($('[name=' + modId + ']').attr('type')) >= 0;

                if (ifModifierCheckbox) {
                    $('#' + modId + '').attr('checked', true);
                }
                if (ifModifierRadio) {
                    if ($('input[type=radio][name=' + modId + '][value=true]').length > 0) {
                        $('input[type=radio][name=' + modId + '][value=true]').prop('checked', true);
                    }
                }
                preventClick = true;

            }
            //Checkbox w/ Data-code and Data-Code-Modifier only (Alt code is selected) 
            else if (isCheckboxWithModifier) {
                var modId = checkboxWithModifier.attr('data-code-modifier');

                checkableEle = checkboxWithModifier;
                preventClick = true;
                $('#' + modId + '').attr('checked', true);

            }
            else if (isSingleCheckbox) {
                checkableEle = singleCheckbox;
                preventClick = true;
            }
        }

        if (checkableEle != null) {
            if (!preventCheck) {
                checkableEle.attr('checked', 'checked');
            }
            if (!preventClick) {
                checkableEle.trigger('click');
            }
        }

        //Multiple Data-Codes + Multiple Selects

        var dcMultiSelect = $('[data-code*=' + id + '][data-select-id*=","][data-code-toggle=true]');
        var dcMultiSelectCodes = dcMultiSelect.attr('data-code');
        var dcMultiSelectId = dcMultiSelect.attr('data-select-id');
        var usesDcMultiSelect = false;

        if ($(dcMultiSelect).length > 0 && $('#' + $(dcMultiSelect).attr('data-select-id')).length > 0) {

            if (dcMultiSelectCodes.indexOf(',') > -1) {

                var dcMultiSelectCodesArray = dcMultiSelectCodes.replace(' ', '').split(',');

                for (var i = 0; i < dcMultiSelectCodesArray.length; i++) {

                    if (id == dcMultiSelectCodesArray[i]) {
                        usesDcMultiSelect = true;
                    }

                }
            }
            else if (id == dcMultiSelectCodes) {
                usesDcMultiSelect = true;
            }

            if (usesDcMultiSelect) {

                var selectableEle;

                if (dcMultiSelectId.indexOf(',') > -1) {
                    var dcMultiSelectors = dcMultiSelectId.split(',');

                    for (var i = 0; i < dcMultiSelectors.length; i++) {

                        if ($('#' + dcMultiSelectors[i]).length > 0) {
                            var dcMultiSelectProduct = $('#' + dcMultiSelectors[i]).attr('data-select-product');

                            if (dcMultiSelectProduct == id) {
                                selectableEle = $('#' + dcMultiSelectors[i]);
                            }
                        }
                    }

                    if (selectableEle.length > 0) {
                        $(selectableEle).val(qty);
                    }

                    registerEvent("ToggleButtonInitialized", function () {
                        setToggleButton(id, 'Add');
                    });


                }
            }
        }

        // Data-Code + Select
        var dcSelect = $('[data-code=' + id + '][data-select-id][data-code-toggle=true]');
        if ($(dcSelect).length <= 0) {
            dcSelect = $('[data-code-alt=' + id + '][data-select-id][data-code-toggle=true]');
        }

        if ($(dcSelect).length > 0 && $('#' + $(dcSelect).attr('data-select-id')).length > 0) {

            var selectableEle = $('#' + $(dcSelect).attr('data-select-id'));

            $(selectableEle).val(qty);

            registerEvent("ToggleButtonInitialized", function () {
                setToggleButton(id, 'Add');
            });

        }

        // Regular Data Code w/ Toggle Button
        var toggleButton = $('[data-code=' + originalId + '][data-code-toggle=true]');

        if (toggleButton.length > 0) {
            registerEvent("ToggleButtonInitialized", function () {
                setToggleButton(originalId, 'Add');
            });
        }

        // Regular Action Code / Quantity
        if ($('[name="ActionCode' + index + '"]').length == 0 || 'radio,checkbox'.indexOf(ele.attr('type')) >= 0) {
            if (!ele.is(':checked')) {
                ele.attr('checked', 'checked');
                ele.trigger('click');
            }

            if ($('#ActionQuantity' + index).length > 0) {
                $('#ActionQuantity' + index).val(qty);
            }
        }
        else {
            $('#ActionQuantity' + index).val(qty);
        }

        // Set Data-Conditions
        $.each($('[data-condition="' + id + '"][data-condition-value]:not([data-condition-missing])'), function () {
            setDataCondition(this);
        });

        //Set qty value for Select with radio/checkbox
        var qtySelect = $('[data-code=' + id + '][data-qty-id][type=radio],[data-code=' + id + '][data-qty-id][type=checkbox]');
        if ($(qtySelect).length <= 0) {
            qtySelect = $('[data-code-alt=' + id + '][data-qty-id][type=radio],[data-code-alt=' + id + '][data-qty-id][type=checkbox]');
        }

        if ($(qtySelect).length > 0 && $('#' + $(qtySelect).attr('data-qty-id')).length > 0) {
            var selectableEle = $('#' + $(qtySelect).attr('data-qty-id'));

            $(selectableEle).val(qty);
        }

    }

    function setDataCondition(obj) {
        var conditionMet = true;
        var type =
            $(obj).is('input[type="checkbox"]') ? "Checkbox" :
                $(obj).is('input[type="radio"]') ? "Radio" :
                    "Text";
        var conditionValue = $(obj).attr('data-condition-value');

        if ($(this).attr('data-condition-qty') != null && $(obj).attr('data-condition-qty').length >= 0) {
            conditionMet = qty == parseInt($(obj).attr('data-condition-qty'));
        }

        if (conditionMet) {
            switch (type) {
                case "Checkbox":
                    if (conditionValue.toLowerCase() == "true") {
                        if (!$(obj).is(':checked')) {
                            $(obj).trigger('click');
                        }
                    }
                    else if (conditionValue.toLowerCase() == "false") {
                        if ($(obj).is(':checked')) {
                            $(obj).trigger('click');
                        }
                    }
                    else {
                        console.log('Condition Value for Checkboxes must be set to "true" or "false"');
                    }
                    break;
                case "Radio":
                    $(obj).attr('checked', 'checked');
                    $(obj).trigger('click');
                    break;
                case "Text":
                    $(obj).val(conditionValue);
                    break;
            }
        }
    }

    function handleCartChange(<%if (enableEditableQuantity && !enableCustomCartMode)
    {%>addItemId, overrideQty, atr, removeItems, additionalItems, evt<%}%>) {
        if (typeof (onCartChangeBegin) == "function") {
            onCartChangeBegin();
        }

	 <%if (!enableEditableQuantity || enableClearCartOnAdd)
    {%>
        $.get(getCartUrl('ClearCart'), { t: new Date().getTime(), covid: '<%=DtmContext.VersionId%>', zipcode: getZip(), state: getState(), country: getCountry() }, function () {
		<%}%>
            var html = '';

            var payload = { t: new Date().getTime(), covid: '<%=DtmContext.VersionId%>', zipcode: getZip(), state: getState(), country: getCountry() };
            var uniqueItems = getItems();
            var qtyCounter = uniqueItems.length;

            var toggleItems = [];
            var toggleButtonCaller = null;

            if (typeof (evt) !== 'undefined') {
                var ev = typeof (event) === 'undefined' ? evt : evt || event;
                if (ev != null && ev.currentTarget != null && $(ev.currentTarget).attr('data-code') != null) {
                    toggleButtonCaller = ev.currentTarget;
                    var tempdatacode = $(toggleButtonCaller).attr('data-code');
                    //Toggle Button Click
                    if ($(ev.currentTarget).attr('data-code-toggle') != null && $(ev.currentTarget).attr('data-code-toggle') == 'true') {
                        var isModified = ($(toggleButtonCaller).attr('data-code-modifier') != null && $(toggleButtonCaller).attr('data-code-modifier').length > 0
                            && $(toggleButtonCaller).attr('data-code-alt') != null && $(toggleButtonCaller).attr('data-code-alt').length > 0
                            && $('#' + $(toggleButtonCaller).attr('data-code-modifier')).is(':checked'));
                        //var tempdatacode = $(toggleButtonCaller).attr('data-code');
                        tempdatacode = isModified ? $(toggleButtonCaller).attr('data-code-alt') : tempdatacode;
                        var regex;
                        if (tempdatacode.indexOf(',') > -1) {
                            tempdatacode = tempdatacode.replace(',', ')$|^(');
                            regex = new RegExp("^(" + tempdatacode + ")$");
                        }
                        else {
                            regex = new RegExp("^" + tempdatacode + "$");
                        }



                        var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                        var $toggleButtonCaller = $(toggleButtonCaller).find('[data-code-label]').length > 0
                            ? $(toggleButtonCaller).find('[data-code-label]')
                            : $(toggleButtonCaller);

                        $toggleButtonCaller.html(active ? 'Removing...' : 'Adding...');
                    }

                    else if (overrideQty == null) {
                        var qtyOverride = $(toggleButtonCaller).attr('data-qty-override');
                        if (qtyOverride != null) {
                            overrideQty = qtyOverride;
                        }
                        else {
                            var actionCode = $('[name*="ActionCode"][value="' + tempdatacode + '"]');
                            if (actionCode != null && actionCode.length > 0) {
                                var actionQty = $('[name*="ActionQuantity' + $(actionCode).attr('id').replace('ActionCode', '') + '"]');
                                if (actionQty != null) {
                                    overrideQty = $(actionQty).val();
                                }
                            }
                        }

                    }
                }
            }

            for (var index = 0; index < uniqueItems.length; index++) {
                var item = uniqueItems[index];
                if (item.id != '' && item.id != 'none') {
                    payload['Item' + index] = item.id;
                    payload['Qty' + index] = item.qty;
                    payload['Atr' + index] = item.atr;


                    var isGroup = false;
                    $("[data-group-name][data-code-toggle=true]").each(function (i, v) {
                        var groupName = $(this).attr('data-group-name');

                        $('select[name=' + groupName + '] option[value=' + item.id + ']').parent().each(function (j, z) {
                            isGroup = true;
                            if (item.qty == 0) {
                                setToggleButton(groupName, 'Remove');
                            }
                            toggleItems.push(groupName);
                        });

                        $('input[type=radio][name=' + groupName + '][value=' + item.id + ']').each(function (j, z) {
                            isGroup = true;
                            if (item.qty == 0) {
                                setToggleButton(groupName, 'Remove');
                            }
                            toggleItems.push(groupName);
                        });

                        $('input[type=checkbox][name=' + groupName + '][value=' + item.id + ']').each(function (j, z) {
                            isGroup = true;
                            if (item.qty == 0) {
                                setToggleButton(groupName, 'Remove');
                            }
                            toggleItems.push(groupName);
                        });
                    });

                    if (item.qty == 0) {
                        if (!isGroup) {

                            setToggleButton(item.id, 'Remove');

                            toggleItems.push(item.id);
                        }
                    }

                }
            }

               <%if (enableEditableQuantity)
    {%>
            if (typeof addItemId == "string") {
                var hasOverrideQty = !(typeof overrideQty == "undefinied" || overrideQty == null);
                var itemExists = false;
                for (var index = 0; index < uniqueItems.length; index++) {
                    if (payload['Item' + index] == addItemId) {
                        var qty = payload['Qty' + index];
                        if (!hasOverrideQty) {
                            payload['Qty' + index] = qty + 1;
                        } else {
                            payload['Qty' + index] = overrideQty;
                        }
                        payload['Atr' + index] = atr;
                        itemExists = true;
                        break;
                    }
                }
                if (!itemExists && addItemId != '') {
                    qtyCounter++;
                    payload['Item' + qtyCounter] = addItemId;
                    payload['Qty' + qtyCounter] = !hasOverrideQty ? 1 : overrideQty;
                    payload['Atr' + qtyCounter] = atr;
                    toggleItems.push(addItemId);
                }


                if (additionalItems != null && additionalItems.length > 0) {
                    for (var i = 0; i < additionalItems.length; i++) {
                        var extra = additionalItems[i];
                        var extraId = extra.Id;
                        var extraQty = extra.Qty;
                        if (extraId != '' && extraId != addItemId && removeItems.indexOf(extraId) < 0) {
                            qtyCounter++;
                            payload['Item' + qtyCounter] = extraId;
                            payload['Qty' + qtyCounter] = extraQty;
                            toggleItems.push(extraId);
                        }
                    };
                }

                if (removeItems != null && removeItems.length > 0) {
                    for (var i = 0; i < removeItems.length; i++) {
                        var removeItem = removeItems[i];
                        if (removeItem != '' && removeItem != addItemId) {
                            qtyCounter++;
                            payload['Item' + qtyCounter] = removeItem;
                            payload['Qty' + qtyCounter] = 0;
                            toggleItems.push(removeItem);
                        }
                    };
                }
            }
            <%}%>

            $('.ddlPromo').each(function (index, item) {

                //if digits or not a space,number, hyphen or letter, then don't let keypress work.
                $(item).keydown(function (event) {
                    var inputValue = event.which;

                    if ((inputValue > 64 && inputValue < 91) // uppercase
                        || (inputValue >= 96 && inputValue < 123) // lowercase + numpad numbers
                        || (inputValue >= 48 && inputValue <= 57) // numbers
                        || inputValue == 9 //tab
                        || inputValue == 8// backspace
                        || inputValue == 46 // delete key
                        || (inputValue >= 37 && inputValue <= 40)) // arrows
                    {
                        return;
                    }
                    event.preventDefault();
                });

                //if value contains symbol , clear field
                $(item).on("input", function (e) {
                    var value = $(item).val();
                    var regex = new RegExp("[^A-Za-z0-9]");
                    if (regex.test(value)) {
                        $(item).val("");
                    }
                });

                var id = $(item).val();
                payload['PromoCode'] = id;
            });

            $('.cartParam').each(function (index, item) {
                var id;
                var paramName = $(item).data('paramname') || item.name;
                if ('radio'.indexOf($(item).attr('type')) >= 0) {
                    id = $('[name=' + item.name + ']:checked').val();
                }
                else if ('checkbox'.indexOf($(item).attr('type')) >= 0) {
                    id = $('[name=' + item.name + ']').is(':checked');
                }
                else {
                    id = $(item).val();
                }
                if (payload["param_" + paramName] == null || payload["param_" + paramName] == '') {
                    payload["param_" + paramName] = id;
                }
            });


            $.post(getCartUrl('Edit'),
                payload,
                function (data) {
                    <%if (!enableKeepItemIfZero)
    {%>
                    $('.reviewTableBody').html('');
                    $('#orderFormReviewTableItems').html('');
                    $('.futurechargerow').html('');
       <%}%>

    <%
    foreach (var code in hiddenCodes)
    {
    %>
                    data.items = data.items.filter(item => item.id !== '<%=code%>');
    <%
    }
    %>

                    var totalQty = 0;

					<%if (showFutureChargesSubTable || showFullPaymentSummarySubTable)
    {%>
                    var extendedPriceTotals = [];
					<%}%>

                    for (var i = 0; i < data.items.length; i++) {
                        var excludeFromCartCount = false;
                        var dataItem = data.items[i];
                        if (dataItem.props && dataItem.props.length > 0) {
                            for (var pi = 0; pi < dataItem.props.length; pi++) {
                                var prop = dataItem.props[pi];
                                dataItem.props[prop["Key"]] = prop["Value"];

                                if (prop["Key"] == "ExcludeFromCartCount" && prop["Value"] == 'true') {
                                    excludeFromCartCount = true;
                                }
                            }
                        }
                        if (!excludeFromCartCount) {
                            totalQty += dataItem.qty;
                        }
                        <% if (enableKeepItemIfZero)
    {%>
                        updateTr(dataItem, i);

                        <%}
    else
    {%>
                        var tr = renderTr(dataItem, i);
                        $('.reviewTableBody').append(tr);
                        <%}%>
                        <%if (showFutureChargesSubTable || showFullPaymentSummarySubTable)
    {%>
                        if (dataItem.numpay > 1) {
                            extendedPriceTotals.push({ item: dataItem, total: dataItem.extPrice * dataItem.qty });
                        }
                        <%}%>

                        <%if (enableEditableQuantity && !enableCustomCartMode)
    {
        if (enableKeepItemIfZero)
        {
        %>
                        updateItemHtml(dataItem, i);
                        <%}
    else
    { %>
                        $('#orderFormReviewTableItems').append(getItemHtml(dataItem, i));
                    <%}%>
                        var dataSelect = $("[data-code='" + dataItem.code + "'][data-select-id]");
                        if (dataSelect.length > 0) {
                            $("#" + dataSelect.attr("data-select-id")).val(dataItem.qty);
                        }
                        var dataCodeSelect = $("select[data-code=" + dataItem.code + "], select[data-code-alt=" + dataItem.code + "]");
                        if (dataCodeSelect.length > 0) {
                            dataCodeSelect.val(dataItem.qty);
                        }
    <%}%>               

                    }

                    <%if (enableKeepItemIfZero)
    {%>
                    updateCartItems(data.items);
                    updateRemovedTr();
    <%}%>

					<%if (enableAddPhToSubtotal)
    {%>
                    var subtotal = (parseFloat(data.totalPrice) + parseFloat(data.totalShipping)).toFixed(2);
				    <%}
    else
    {%>
                    var subtotal = data.totalPrice.toFixed(2);
					 <%}%>
                    $('.subtotal').html('<%=currencySymbol%>' + subtotal);
                    $('.phtotal').html('<%=currencySymbol%>' + data.totalShipping.toFixed(2));
                    $('.summary-total').html('<%=currencySymbol%>' + data.total.toFixed(2));
                    $('.cartTotalQty').html(totalQty > 0 ? '(' + totalQty + ')' : '');
                    $('.cartTotalQtyNumbersOnly').html(totalQty > 0 ? '' + totalQty + '' : '');
                    setTax(data.zipdata);
                    displayError(data.errors);

                    if (payload['PromoCode'] && typeof (onApplyPromo) == "function") {
                        var promoCode = payload['PromoCode'];
                        var hasPromo = promoCode == data.promoCode;
                        var promoItem = getItemWithKeyValue(data.items, 'id', data.promoCodeTarget);
                        if (hasPromo && promoItem != null) {
                            var fireOnApplyPromo = false;
                            $('.ddlPromo').each(function (i, item) {
                                var current = $(item).attr('data-current');
                                if (typeof (current) == "undefined" || current != promoCode) {
                                    $(item).attr('data-current', promoCode);
                                    fireOnApplyPromo = true;
                                }
                            });
                            if (fireOnApplyPromo) {
                                onApplyPromo(promoCode, promoItem);
                            }
                        }
                    }

					<%if (showFutureChargesSubTable || showFullPaymentSummarySubTable)
    {%>
                    var futureChargesValues = new Array();
                    var extendedOrderTotal = (data.zipdata != null) ? data.total + data.zipdata.Amount : data.total;
                    for (var key in extendedPriceTotals) {
                        if ($.isNumeric(key)) {
                            var numPayments = extendedPriceTotals[key].item.numpay - ((extendedPriceTotals[key].item.price + extendedPriceTotals[key].item.shipping) !== 0 ? 1 : 0);
                            var monthlyTotal = parseFloat(extendedPriceTotals[key].total) / numPayments;
                            extendedOrderTotal += monthlyTotal;
                            for (var i = 0; i < numPayments; i++) {
                                if (futureChargesValues[i] == undefined) {
                                    futureChargesValues[i] = monthlyTotal;
                                }
                                else {
                                    futureChargesValues[i] += monthlyTotal;
                                }
                            }
                        }
                    }
                    var startingLabelIndex = <%=SettingsManager.ContextSettings["SummaryReviewTable.FutureChangesStartingIndex", 2]%>;
                    var labelCount = startingLabelIndex;
                    <%if (showFutureChargesSubTable)
    {%>
                    var tr = '<tr class="futurechargerow"><td colspan="' + <%=totalColumnLength + 1%> + '"><b>' + "<%=textFutureCharges%>" + '</b></td></tr>';
                    if (futureChargesValues.length > 0) {
                        for (var i = 0; i < futureChargesValues.length; i++) {
                            tr += '<tr class="futurechargerow"><td colspan="' +<%=totalColumnLength%> +'"><i>' + getFutureChargesLabels(labelCount, startingLabelIndex) + '</i></td><td> $' + futureChargesValues[i].toFixed(2) + '</td></tr>';
                            labelCount++;
                        }
                        $('.reviewTableFoot').append(tr);
                    }
                    <%}
    if (showFullPaymentSummarySubTable)
    {%>
                    if (futureChargesValues.length > 0) {
                        var taxAmount = (data.zipdata != null) ? data.zipdata.Amount : 0;
                        var tr = '<tr class="futurechargerow"><th colspan="' + <%=totalColumnLength + 1%> + '">Full Payment Summary</th></tr>';
                        tr += '<tr class="futurechargerow"><td colspan="' +<%=totalColumnLength + 1%> +'"><label class="firstPayment">' + getFirstPaymentLabel(data.totalPrice, data.totalShipping, taxAmount) + '</label></td></tr>';
                        for (var i = 0; i < futureChargesValues.length; i++) {
                            tr += '<tr class="futurechargerow"><td colspan="' +<%=totalColumnLength + 1%> +'">' + getExtendedPaySummaryLabels(labelCount) + futureChargesValues[i].toFixed(2) + '</td></tr>';
                            labelCount++;
                        }
                        tr += '<tr class="futurechargerow"><td colspan="' +<%=totalColumnLength%> +'">Total Order Amount</td><td><%=currencySymbol%>' + extendedOrderTotal.toFixed(2) + '</td></tr>';
                        $('.reviewTableFoot').append(tr);
                    }
                   <%}%> 
			    <%}%>
                    function getFutureChargesLabels(labelCount, startingLabelIndex) {
                        <% 
    var daysLabel = LabelsManager.Labels["DaysLabel"] != null ? LabelsManager.Labels["DaysLabel"] : "";
    var firstFutureChargeText = LabelsManager.Labels["FirstFutureChargeLabel"] != null ? LabelsManager.Labels["FirstFutureChargeLabel"] : "";
    var secondFutureChargeText = LabelsManager.Labels["SecondFutureChargeLabel"] != null ? LabelsManager.Labels["SecondFutureChargeLabel"] : "";
    var thirdFutureChargeText = LabelsManager.Labels["ThirdFutureChargeLabel"] != null ? LabelsManager.Labels["ThirdFutureChargeLabel"] : "";
    var thFutureChargeText = LabelsManager.Labels["thFutureChargeLabel"] != null ? LabelsManager.Labels["thFutureChargeLabel"] : "";
                        %>

                     var additive = labelCount - startingLabelIndex;
                     var days = (additive + 1) * 30;

                     switch (labelCount) {
                         case 1:
                             var firstFutureChargeLabel = "<%=firstFutureChargeText%>" != "" ? "1<%=firstFutureChargeText%> " + days + " <%=daysLabel%>" : "1st Payment in " + days + " days";
                                return firstFutureChargeLabel;
                            case 2:
                                var secondFutureChargeLabel = "<%=secondFutureChargeText%>" != "" ? "2<%=secondFutureChargeText%> " + days + " <%=daysLabel%>" : "2nd Payment in " + days + " days";
                                return secondFutureChargeLabel;
                            case 3:
                                var thirdFutureChargeLabel = "<%=thirdFutureChargeText%>" != "" ? "3<%=thirdFutureChargeText%> " + days + " <%=daysLabel%>" : "3rd Payment in " + days + " days";
                                return thirdFutureChargeLabel;
                            default:
                                var thFutureChargeLabel = "<%=thFutureChargeText%>" != "" ? labelCount + "<%=thFutureChargeText%> " + days + " <%=daysLabel%>" : labelCount + "th Payment in " + days + " days";
                                return thFutureChargeLabel;
                        }
                    }
                    function getFirstPaymentLabel(price, shipping, tax) {

                        <% 
    var fullPaymentSummaryLabel = LabelsManager.Labels["FullPaymentSummaryLabel"] != null ? LabelsManager.Labels["FullPaymentSummaryLabel"] : "";
    var yourLabel = LabelsManager.Labels["YourLabel"] ?? "";
    var firstFullPaymentSummaryLabel = LabelsManager.Labels["FirstFullPaymentSummaryLabel"] != null ? LabelsManager.Labels["FirstFullPaymentSummaryLabel"] : "";
    var secondFullPaymentSummaryLabel = LabelsManager.Labels["SecondFullPaymentSummaryLabel"] != null ? LabelsManager.Labels["SecondFullPaymentSummaryLabel"] : "";
    var thirdFullPaymentSummaryLabel = LabelsManager.Labels["ThirdFullPaymentSummaryLabel"] != null ? LabelsManager.Labels["ThirdFullPaymentSummaryLabel"] : "";
    var thFullPaymentSummaryLabel = LabelsManager.Labels["thFutureChargeLabel"] != null ? LabelsManager.Labels["thFutureChargeLabel"] : "";
                        %>

                     var shippingString = (shipping > 0) ? " + <%=currencySymbol%>" + shipping.toFixed(2) : "";
                     var taxString = (tax > 0) ? " + <%=currencySymbol%>" + tax.toFixed(2) : "";
                     if (shipping > 0 || tax > 0) {
                         return "Your 1st payment is " + "<%=currencySymbol%>" + price.toFixed(2) + shippingString + taxString;
                        }
                        return "Your 1st payment is " + price.toFixed(2);
                    }
                    function getExtendedPaySummaryLabels(labelCount) {
                        switch (labelCount) {
                            case 2:
                                label = "Your 2nd payment is <%=currencySymbol%>";
                                break;
                            case 3:
                                label = "Your 3rd payment is <%=currencySymbol%>";
                                break;
                            default:
                                label = "Your " + labelCount + "th payment is <%=currencySymbol%>";
                                break;
                        }
                        return label;
                    }
                    if (typeof (onCartChangeComplete) == "function") {
                        onCartChangeComplete();
                    }

                    if (_dtmShoppingCart != null) {
                        setTimeout(function () { }, 800);

                        var rbgroups = [];

                        for (var i = 0; i < toggleItems.length; i++) {
                            var toggleItem = toggleItems[i];
                            var code = toggleItem;
                            var regex = new RegExp("^" + toggleItem + "$");
                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                            var isGroup = $('input[type=radio][name=' + toggleItem + ']').length > 0;
                            code = $('input[type=radio][value=' + toggleItem + '][name]:checked').length > 0 ? $('input[type=radio][value=' + toggleItem + '][name]:checked').attr('name') : code;

                            if (isGroup) {

                                var selectedItem = $('input[type=radio][name=' + toggleItem + ']:checked').val();
                                var cartRegex = new RegExp("^" + selectedItem + "$");
                                var cartItem = _dtmShoppingCart.SearchItems(cartRegex);
                                var hasItem = cartItem.length > 0;
                                if (hasItem) {
                                    setToggleButtonQty(code, cartItem.TotalQuantity);
                                }
                            }

                            setToggleButton(code, active ? 'Add' : 'Remove');
                        };

                        $('[data-code-toggle=true][data-code]').not('[data-code-modifier]').each(function (index, item) {
                            var code = $(this).attr('data-code');

                            if (code.indexOf(',') > -1) {

                                var allDataCodes = code.split(',');
                                var datacodes = code.replace(',', ')$|^(');
                                var regex = new RegExp("^(" + datacodes + ")$");
                                var active = _dtmShoppingCart.SearchItems(regex).length > 0;


                                setToggleButton(code, active ? 'Add' : 'Remove');


                            }
                            else {
                                var isCB = 'checkbox'.indexOf($(this).attr('type')) >= 0;

                                var code = $(this).attr('data-code');
                                var regex = new RegExp("^" + code + "$");
                                var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                                if (isCB) {
                                    $(this).prop("checked", active);
                                }
                                setToggleButton(code, active ? 'Add' : 'Remove');
                            }
                        });

                        $("[data-code-toggle=true][data-group-name]").each(function (i, item) {
                            var groupName = $(this).attr('data-group-name');
                            var isDataCheckbox = $(this).attr('data-checkbox') != null && $(this).attr('data-checkbox').length > 0;
                            var altCodes = "";
                            var hasQtySelect = $(this).attr('data-qty-id');
                            var selector = ($(item)[0].hasAttribute('data-select')) ?
                                ('[name="' + groupName + '"] option[value != ""]') :
                                ('[name="' + groupName + '"]');

                            var removeItems = [];
                            var dataCodes = $(selector)
                                .map(function () { return this.value; })
                                .get().join(')$|^(');

                            var hasModifier = $(this).attr('data-code-modifier') != null && $(this).attr('data-code-modifier').length > 0;

                            if (hasModifier) {
                                altCodes = $('[name="' + groupName + '"]')
                                    .map(function () { return $(this).attr('data-code-alt'); })
                                    .get().join(')$|^(');
                            }

                            var regex = hasModifier ? new RegExp("^(" + dataCodes + ")$|^(" + altCodes + ")$") : new RegExp("^(" + dataCodes + ")$");
                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                            setToggleButton(groupName, active ? 'Add' : 'Remove');

                            if (active && typeof hasQtySelect !== typeof undefined) {
                                setToggleButtonQty(groupName, _dtmShoppingCart.SearchItems(regex).TotalQuantity);
                            }

                            if (isDataCheckbox) {
                                $('[name="' + groupName + '"]').each(function (idx, cbx) {

                                    var modifier = hasModifier ? $(cbx).attr('data-code-modifier') : null;
                                    var isModified = modifier != null ? $('#' + modifier + '').is(':checked') : false;
                                    var code = isModified ? $(cbx).attr('data-code-alt') : $(cbx).val();
                                    var regex = new RegExp("^" + code + "$");
                                    var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                                    $(cbx).prop("checked", active);

                                });
                            }

                        });

                        $('[data-code-toggle=true][data-code][data-code-modifier][data-code-alt]').each(function (index, item) {
                            var oldCode = $(this).attr('data-code');
                            var alt = $(this).attr('data-code-alt');
                            var modifier = $(this).attr('data-code-modifier');

                            var isChecked = $('#' + modifier).is(':checked');
                            var code = !isChecked ? $(this).attr('data-code') : $(this).attr('data-code-alt');

                            var regex = new RegExp("^" + code + "$");
                            var active = _dtmShoppingCart.SearchItems(regex).length > 0;
                            setToggleButton(oldCode, active ? 'Add' : 'Remove');
                        });
                    }

                    $('[data-code-toggle=true]').removeClass('disableToggleClick');

                    //Check if cart has any multipay items
                    var hasMultipay = false;
                    for (var i = 0; i < data.items.length; i++) {
                        var item = data.items[i];
                        if (item && item.numpay && item.numpay > 1) {
                            hasMultipay = true;
                            break;
                        }
                    }

                    <%
    if (enableToggleShippingFields)
    { %>
                    //Toggle shipping Fields
                    toggleShippingFields(hasMultipay);
                    <%
    } %>
                    data.hasMultipay = hasMultipay;
                    _dtmShoppingCart.HasMultipay = hasMultipay;
                    triggerEvent("CartChange", data);

                }, "json")
                .error(function () {
                    if (typeof (onCartChangeComplete) == "function") {
                        onCartChangeComplete();
                    }
                    $('[data-code-toggle=true]').removeClass('disableToggleClick');
                });
            <%if (!enableEditableQuantity || enableClearCartOnAdd)
    {%>
        });
		<%}%>
    }

    function displayError(errorArray) {
        if (errorArray && errorArray.length > 0) {
            var ele = $('form').find('span[style="color: #FF0000; font-weight: bold"]');

            if (ele.length == 0 && $('.vse').length > 0) {
                ele = $('.vse');
            }

            if (_firstRun) {
                if (ele.children().length) {
                    $.each(ele.find('li'), function (index, item) {
                        data.errors.push($(item).text());
                    });
                }
            }

            var html = '<div class="validation-summary-errors"><span><%=textErrorMessage%></span>' + '<ul>';
            for (var i = 0; i < errorArray.length; i++) {
                if (html.indexOf(errorArray[i]) < 0) {
                    html += '<li>' + errorArray[i] + '</li>';
                }
            }
            html += '</ul></div>';
            if (!_firstRun) {
                ele.html(html);
                _dtmShoppingCart.ScrollToErrors(ele);
            } else {
                _firstRun = false;
            }
        } else if (!_firstRun) {
            var ele = $('form').find('span[style="color: #FF0000; font-weight: bold"]');
            if (ele.length == 0 && $('.vse').length > 0) {
                ele = $('.vse');
            }
            ele.html('');
        }
    }

    function setToggleButton(code, mode) {
        triggerEvent("ChangeToggleButtonState", {
            key: code,
            state: mode
        });
    }

    function registerEvent(evType, fn, element, useCapture) {
        var elm = element || window;
        if (elm.addEventListener) {
            elm.addEventListener(evType, fn, useCapture || false);
        }
        else if (elm.attachEvent) {
            var r = elm.attachEvent(evType, fn);
        }
        else {
            elm[evType] = fn;
        }
    }

    function triggerEvent(eventName, data, element) {
        try {
            var event;
            var payload = (data && typeof (data.detail) != "undefined")
                ? data
                : (data ? { detail: data } : { detail: '' });
            if (typeof window.CustomEvent === 'function') {
                event = new CustomEvent(eventName, payload || { detail: '' });
            } else if (document.createEvent) {
                event = document.createEvent('HTMLEvents');
                event.detail = payload.detail;
                event.initEvent(eventName, true, true);
            } else if (document.createEventObject) {
                event = document.createEventObject();
                event.detail = payload.detail;
                event.eventType = eventName;
            }
            event.eventName = eventName;
            var el = element || window;
            if (el.dispatchEvent) {
                el.dispatchEvent(event);
            } else if (el.fireEvent && htmlEvents[eventName]) {
                el.fireEvent(event.eventType, event);
            } else if (el[eventName]) {
                el[eventName]();
            } else if (el['on' + eventName]) {
                el['on' + eventName]();
            }
        } catch (error) {
            console.log('Error executing ' + name + ' Event');
        }
    }

    function getItemWithKeyValue(items, key, value) {
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item[key] == value) {
                return item;
            }
        }
        return null;
    }

    function renderTr(dataItem, i) {
        if (!dataItem.props["HideProduct"]) {
            var tr = '<tr>';
            tr += '<td data-sku="' + dataItem.sku +'" data-eflex--category-label="Sku"><span class="orderItemsLabel"> ' + dataItem.sku + '</span></td>';
            tr += '<td data-eflex--category-label="Item">' + dataItem.name + '</td>';
        <%if (enableEditableQuantity)
    {%>
            var hasNoEditButton = $('[data-code=' + dataItem.code + '][data-code-toggle=true][data-noedit=true]').length > 0
                || $('[data-code][data-code-alt=' + dataItem.code + '][data-code-toggle=true][data-noedit=true]').length > 0;

            var noEditInput = $('[name=NoEdit][type=hidden]');
            if (noEditInput.length > 0) {
                var noEditArray = noEditInput.val().split(',');

                hasNoEditButton = (noEditArray.indexOf(dataItem.code) > -1);
            }

            if (dataItem.props["NoEdit"] || hasNoEditButton) {
                tr += '<td data-cart-code="' + dataItem.code + 'Quantity" data-cart-noedit="true" data-eflex--category-label="<%=textQuantityColumn%>">' + dataItem.qty + getQuantityHtml(dataItem, i) + '</td>';
            } else {
                tr += '<td data-cart-code="' + dataItem.code + 'Quantity" data-eflex--category-label="<%=textQuantityColumn%>">' + getQtyDdl(dataItem, i, '<%=enableZeroQuantity%>') + '</td>';
            }
        <%}
    else
    {%>
            tr += '<td data-cart-code="' + dataItem.code + 'Quantity" data-eflex--category-label="<%=textQuantityColumn%>">' + dataItem.qty + '</td>';
            <%}%>
        <%if (showPriceColumn)
    {%>
            tr += '<td data-cart-code="' + dataItem.code + 'Price" data-eflex--category-label="<%=textPriceColumn%>"><%=currencySymbol%>' + (dataItem.price * dataItem.qty).toFixed(2) + '</td>';
            <%}%>
        <%if (showShippingColumn)
    {%>
            tr += '<td data-cart-code="' + dataItem.code + 'Shipping" data-eflex--category-label="<%=textShippingColumn%>"><%=currencySymbol%>' + (dataItem.shipping * dataItem.qty).toFixed(2) + '</td>';
            <%}%>
        <%if (showRemoveButtonColumn)
    {%>
            var currentItemIndex = ($('[name*=ActionCode][value="' + dataItem.id + '"]').attr('id') || '').replace('ActionCode', '');
            if (dataItem.props["NoEdit"]) {
                tr += '<td></td>';
            }
            else {
                tr += '<td><a href="javascript:void(0);" onclick="javascript:$(\'#ActionQuantity' + i + '\').val(0).trigger(\'change\');">Remove</td>';
            }
        <%}%>
            tr += '</tr>';
            return tr;
        }
        return '';
    }

    function updateTr(dataItem, i) {
        var qtyTd = $("[data-cart-code='" + dataItem.code + "Quantity']");
        if (qtyTd.length != 0) {
            var Quantity = qtyTd.children("[name*='ActionQuantity']")[0];
            $(Quantity).val(dataItem.qty);
            if (qtyTd.attr('data-cart-noedit')) {
                qtyTd.html(dataItem.qty);
                qtyTd.append(Quantity);
            }

        <%if (showPriceColumn)
    {%>
            $("[data-cart-code='" + dataItem.code + "Price']").html('<%=currencySymbol%>' + (dataItem.price * dataItem.qty).toFixed(2) + '');
            <%}%>
        <%if (showShippingColumn)
    {%>
            $("[data-cart-code='" + dataItem.code + "Shipping']").html('<%=currencySymbol%>' + (dataItem.shipping * dataItem.qty).toFixed(2) + '');
            <%}%>
        } else {
            i = $('#orderFormReviewTableItems').children("input").length;
            var tr = renderTr(dataItem, i);
            $('.reviewTableBody').append(tr);
        }


    }

    function updateCartItems(dataItems) {
        $(dataItems).each(function (index, item) {
            var exists = false;
            $(cartItems).each(function (i, cartItem) {
                if (cartItem.code == item.code) {
                    cartItem.added = true;
                    exists = true;
                    return;
                }
            });
            if (!exists) { cartItems.push({ code: item.code, added: true }) };
        });

        $(cartItems).each(function (index, cartItem) {
            var exists = false;
            $(dataItems).each(function (i, item) {
                if (cartItem.code == item.code) {
                    exists = true;
                    return;
                }
            });
            cartItem.added = exists;
        });
    }

    function updateRemovedTr() {

        $(cartItems).each(function (index, item) {
            if (!item.added) {
                var qtyTd = $("[data-cart-code='" + item.code + "Quantity']");
                var Quantity = qtyTd.children("[name*='ActionQuantity']")[0];
                $(Quantity).val('0');
                if (qtyTd.attr('data-cart-noedit')) {
                    qtyTd.html('0');
                    qtyTd.append(Quantity);
                }
        <%if (showPriceColumn)
    {%>
                $("[data-cart-code='" + item.code + "Price']").html('<%=currencySymbol%>' + (0).toFixed(2) + '');
            <%}%>
        <%if (showShippingColumn)
    {%>
                $("[data-cart-code='" + item.code + "Shipping']").html('<%=currencySymbol%>' + (0).toFixed(2) + '');
            <%}%>
            }
        });
    }
    function setTax(data) {
        if (data != null) {

            var zip = $('.zc').val();
            var shipZip = $('#ShippingZip').val();
            var billZip = $('#BillingZip').val();
            var shipCity = $('#ShippingCity').val();
            var billCity = $('#BillingCity').val();
            var shipState = $('#ShippingState').val();
            var billState = $('#BillingState').val();
            var shipCountry = $('#ShippingCountry').val();
            var billCountry = $('#BillingCountry').val();

            if ($('#ShippingIsDifferentThanBilling').is(':checked') && lastChangeType == 'Shipping') {
                if (data.City != '' && data.City != null && shipCity == "") {
                    $('#ShippingCity').val(data.City);
                }
                if (data.CountryCode != '' && data.CountryCode != null && shipCountry == "") {
                    $('#ShippingCountry').val(data.CountryCode);
                }
                if (data.StateCode != '' && data.StateCode != null && shipState == "") {
                    $('#ShippingState').val(data.StateCode);
                }
                if (shipZip == "") {
                    $('#ShippingZip').val(zip);
                }
            } else {
                if (data.City != '' && data.City != null && billCity == "") {
                    $('#BillingCity').val(data.City);
                }
                if (data.CountryCode != '' && data.CountryCode != null && billCountry == "") {
                    $('#BillingCountry').val(data.CountryCode);
                }
                if (data.StateCode != '' && data.StateCode != null && billState == "") {
                    $('#BillingState').val(data.StateCode);
                }
                if (billZip == "") {
                    $('#BillingZip').val(zip);
                }
            }
            $('.taxtotal').html('<%=currencySymbol%>' + data.Amount.toFixed(2));
            $('.summary-total').html('<%=currencySymbol%>' + data.TaxTotal.toFixed(2));
        } else {
            $('.taxtotal').html('<%=currencySymbol%>' + (0).toFixed(2));
        }
    }

    function getZip() {
        return $('#zc').val();
    }

    function getState() {
        return $('#ShippingIsDifferentThanBilling').is(':checked') ? $('#ShippingState').val() : $('#BillingState').val();
    }
    function getCountry() {
        return $('#ShippingIsDifferentThanBilling').is(':checked') ? $('#ShippingCountry').val() : $('#BillingCountry').val();
    }

    var currentzipcode = '', lastChangeType = '';
    function updateZip(zipcode, state, country) {
        if (zipcode != '' && zipcode != currentzipcode && zipcode.length >= 5) {
            currentzipcode = zipcode;
            $('.zc').val(zipcode);
            handleCartChange();
        }
    }
    <%if (enableEditableQuantity)
    {%>

    registerEvent("CartChange", function () {
        updateParentCodeQuantity();
    });
    function getQtyDdl(item, index, allowZero) {
        var html = "";

        if (item.id.indexOf("_LI") !== - 1) {
            var parentCode = item.id.split("_")[0];
            var childSuffix = item.id.split("_")[1];

            if (childSuffix == "LI1") {
                html += '<select id="LineItemQuantity' + index + '" name="LineItemQuantity' + index + '" data-parent-code="' + parentCode + '" data-index="' + index + '" onchange="$(\'#ActionQuantity' + index + '\').val(this.value);triggerEvent(\'ActionQuantityChange\', \'' + index + '\');">';
            }
            else {
                var parentCodeIndex = $("input[data-parent-code=" + parentCode + "]").attr("data-index");
                html += '<select id="LineItemQuantity' + index + '" name="LineItemQuantity' + index + '" data-parent-code="' + parentCode + '" data-index="' + parentCodeIndex + '" onchange="$(\'#ActionQuantity' + parentCodeIndex + '\').val(this.value);triggerEvent(\'ActionQuantityChange\', \'' + parentCodeIndex + '\');">';
            }
        }
        else {
            html = '<select id="ActionQuantity' + index + '" name="ActionQuantity' + index + '" data-index="' + index + '" onchange="$(\'#ActionQuantity' + index + '\').val(this.value);triggerEvent(\'ActionQuantityChange\', \'' + index + '\');">';
        }
        for (var i = (allowZero != null && allowZero != 'False' ? 0 : (item.minQty === 0 ? 1 : item.minQty)); i <= item.maxQty; i++) {
            html += '<option value="' + i + '" ' + (item.qty == i ? 'selected="selected"' : '') + '>' + i + '</option>';
        }
        html += ' </select>';
        if (item.id.indexOf("_LI") !== -1) {
            var parentCode = item.id.split("_")[0];
            var childSuffix = item.id.split("_")[1];
            var quantity = item.qty;

            if (childSuffix == "LI1") {
                if ($("input[name=ActionQuantity" + index + "]").length === 0) {
                    $("#orderFormReviewTableItems").after("<input type='hidden' id='ActionQuantity" + index + "' name='ActionQuantity" + index + "' data-index='" + index + "' value='" + quantity + "' data-parent-code='" + parentCode + "' data-cart-code='" + parentCode + "Quantity'/>");
                }
            }
        }

        return html;
    }

    function updateParentCodeQuantity() {
        var items = getItems();
        var parentProducts = [];
        $("input[name^=ActionQuantity]").each(function () {
            if (typeof $(this).attr("data-parent-code") !== "undefined") {
                parentProducts.push({ index: $(this).attr("data-index"), code: $(this).attr("data-parent-code") });
            }
        });
        var parentProductsCount = parentProducts.length;
        if (parentProductsCount > 0) {
            for (var i = 0; i < parentProductsCount; i++) {
                for (var j = 0; j < items.length; j++) {
                    if (parentProducts[i].code === items[j].id) {
                        $("input[name=ActionQuantity" + parentProducts[i].code + "]").val(items[j].qty);
                    }
                }
            }
        }
    }


    function getItemHtml(item, index) {
        var html = "";
        if (item.id.indexOf("_LI") !== -1) {
            var parentCode = item.id.split("_")[0];
            var childSuffix = item.id.split("_")[1];
            var parentIndex = $('[data-parent-code="' + parentCode + '"]').attr("data-index");

            if (childSuffix == "LI1" && $("input[name=ActionCode" + parentIndex + "]").length === 0) {
                html = '<input type="hidden" id="ActionCode' + parentIndex + '" name="ActionCode' + parentIndex + '"' + ' value="' + parentCode + '" />';
            }
        }
        else {
            html = '<input type="hidden" id="ActionCode' + index + '" name="ActionCode' + index + '"' + ' value="' + item.id + '" />';
        }
        return html;
    }

    function updateItemHtml(dataItem, i) {
        var i = $('#orderFormReviewTableItems').children("input").length;
        if ($('#orderFormReviewTableItems').children("[value='" + dataItem.code + "']").length == 0) {
            $('#orderFormReviewTableItems').append(getItemHtml(dataItem, i));
            i++;
        }
    }

    function getQuantityHtml(item, index) {
        return '<input type="hidden" id="ActionQuantity' + index + '" name="ActionQuantity' + index + '"' + ' value="' + item.qty + '" />';
    }

    function setItems(items) {
        $("[name*='ActionQuantity']").each(function (index, item) {
            $(item).val(0);
        });
        $.get(getCartUrl('ClearCart'), { t: new Date().getTime(), covid: '<%=DtmContext.VersionId%>', zipcode: getZip(), state: getState(), country: getCountry() }, function () {
            if (items && items.length > 0) {
                var html = '';
                for (var i = 0; i < items.length; i++) {
                    var item = items[i];

                    if (item.id && item.qty) {
                        html += '<input type="hidden" id="ActionCode' + i + '" name="ActionCode' + i + '" value="' + item.id + '" />'
                            + '<input type="hidden" id="ActionQuantity' + i + '" name="ActionQuantity' + i + '" value="' + item.qty + '" />';
                    }
                }
                $('#orderFormReviewTableItems').html(html);
                handleCartChange();
            }
        });
    }
    <%}%>
    function getItems(items) {
        var uniqueItems = new Array();
        $("[name*='ActionQuantity']").each(function (index, item) {
            var id;
            var itemIndex = (item.getAttribute('data-index') ? item.getAttribute('data-index') : (item.id || '').replace('ActionQuantity', ''));
            if ($('[name="ActionCode' + itemIndex + '"]').length == 0 || 'radio,checkbox'.indexOf($('[name="ActionCode' + itemIndex + '"]').attr('type')) >= 0) {
                if ($('[name="ActionCode' + itemIndex + '"][data-upgrade]').length != 0) {
                    id = $('[name="ActionCode' + itemIndex + '"]').val();
                } else {
                    id = $('[name="ActionCode' + itemIndex + '"]:checked').val();
                }
            } else {
                id = $('[name="ActionCode' + itemIndex + '"]').val();
                if ($('[name="ActionCode' + itemIndex + '"]').attr('data-checkbox')) {
                    var checkBoxName = $('[name="ActionCode' + itemIndex + '"]').attr('name').replace('Code', 'Checkbox');
                    var checkBoxEle = $('[name="' + checkBoxName + '"]');

                    if (checkBoxEle.attr('data-new') == id) {
                        checkBoxEle.prop('checked', true);
                    }
                }
            }
            if (id != null && id != '' && id != 'none') {
                var qty = $(item).val();
                var atr;
                if ($('[name="ActionAttribute' + itemIndex + '"]').length == 0 || 'radio,checkbox'.indexOf($('[name="ActionAttribute' + itemIndex + '"]').attr('type')) >= 0) {
                    if ($('[name="ActionAttribute' + itemIndex + '"]').length == 1) {
                        atr = $('[name="ActionAttribute' + itemIndex + '"]:checked').val();
                    } else {
                        var allValues = new Array();
                        $.each($('[name="ActionAttribute' + itemIndex + '"]:checked'), function () {
                            allValues.push($(this).val());
                        });
                        atr = allValues.join(',');
                    }
                } else {
                    if ($('[name="ActionAttribute' + itemIndex + '"]').length == 1) {
                        atr = $('[name="ActionAttribute' + itemIndex + '"]').val();
                    } else {
                        var allValues = new Array();
                        $.each($('[name="ActionAttribute' + itemIndex + '"]'), function () {
                            allValues.push($(this).val());
                        });
                        atr = allValues.join(',');
                    }
                }
                if (uniqueItems[id]) {
                    for (var ui = 0; ui < uniqueItems.length; ui++) {
                        var uitem = uniqueItems[ui];
                        if (uitem.id == id) {
                            uitem.qty += parseInt(qty);
                            break;
                        }
                    }
                } else {
                    uniqueItems[id] = true;
                    uniqueItems[uniqueItems.length] = { id: id, qty: parseInt(qty), atr: atr };
                }

                if ($('[name="MatchProductQuantity' + itemIndex + '"]').length == 0 || 'radio,checkbox'.indexOf($('[name="MatchProductQuantity' + itemIndex + '"]').attr('type')) >= 0) {
                    var match = $('[name="MatchProductQuantity' + itemIndex + '"]:checked').val();
                } else {
                    var match = $('[name="MatchProductQuantity' + itemIndex + '"]').val();
                }
                if (typeof match != "undefined" && match.length > 0) {
                    if (uniqueItems[match]) {
                        for (var ui = 0; ui < uniqueItems.length; ui++) {
                            var uitem = uniqueItems[ui];
                            if (uitem.id == match) {
                                uitem.qty += parseInt(qty);
                                break;
                            }
                        }
                    } else {
                        uniqueItems[match] = true;
                        uniqueItems[uniqueItems.length] = { id: match, qty: parseInt(qty), atr: atr };
                    }
                }
            } else {
                console.log('id was blank, skipping.')
            }
        });
        return uniqueItems;
    }

    var DtmShoppingCart = function () {
        var self = this;
        self.scrollToTopPosition = parseFloat("<%= SettingsManager.ContextSettings["OrderFormReview.ScrollToPosition", "-200"] %>");

        self.CurrentErrors = [];

        self.Count = function () {
            return self.Items().length;
        }

        self.Items = function () {
            return getItems();
        };

        self.HasMultipay = false;

        self.SearchItems = function (pattern) {
            var items = getItems();
            var results = [];

            results["TotalQuantity"] = 0;

            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                if (new RegExp(pattern).test(item.id)) {
                    results[results.length] = item;
                    results[item.id] = item;
                    results["TotalQuantity"] += item.qty;
                }
            }
            return results;
        };

        self.SetItems = function (items) {
            setItems(items);
        }

        self.AddErrors = function (errorsArray) {
            var allErrors = self.CurrentErrors.concat(errorsArray);

            var uniqueErrors = [];
            for (var i = 0, l = allErrors.length; i < l; i++) {
                if (uniqueErrors.indexOf(allErrors[i]) === -1) {
                    uniqueErrors.push(allErrors[i]);
                }
            }
            self.DisplayErrors(uniqueErrors, true);
            self.ScrollToErrors();
        };

        self.RemoveErrors = function (errorsArray) {
            var currentErrors = self.CurrentErrors;

            var uniqueErrors = [];
            for (var i = 0, l = currentErrors.length; i < l; i++) {
                var currentError = currentErrors[i];
                var alreadyExists = false;
                for (var j = 0; j < errorsArray.length; j++) {
                    var toRemoveError = errorsArray[j];

                    if (currentErrors.indexOf(toRemoveError) > -1 && currentError == toRemoveError) {
                        alreadyExists = true;
                    }
                }

                if (uniqueErrors.indexOf(currentError) === -1 && !alreadyExists) {
                    uniqueErrors.push(currentError);
                }
            }
            self.DisplayErrors(uniqueErrors, true);
        };

        self.ScrollToErrors = function (customElement) {
            if (self.CurrentErrors.length > 0) {
                var ele = getErrorElement();
                $.scrollTo(ele, { top: self.scrollToTopPosition });
            } else if (customElement) {
                $.scrollTo(customElement, { top: self.scrollToTopPosition });
            }
        };

        function getErrorElement() {
            var ele = $('form').find('span[style="color: #FF0000; font-weight: bold"]');

            if (ele.length == 0) {
                //For IE
                ele = $('form').find('span[style="color: rgb(255, 0, 0); font-weight: bold;"]');
            }

            if (ele.length == 0 && $('.vse').length > 0) {
                ele = $('.vse');
            }
            return ele;
        }

        self.UpgradeItem = function (currentCode, newCode) {
            var items = self.Items();

            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                if (item.id == currentCode) {
                    item.id = newCode;
                    break;
                }
            }

            self.SetItems(items);
        };

        self.DisplayErrors = function (errorsArray, show) {
            if (errorsArray && errorsArray.length > 0) {
                var ele = getErrorElement();

                if (_firstRun) {
                    if (ele.children().length) {
                        $.each(ele.find('li'), function (index, item) {
                            errorsArray.push($(item).text());
                        });
                    }
                }

                var html = '<div class="validation-summary-errors"><span><%=textErrorMessage%></span>' +
                    '<ul>';
                for (var i = 0; i < errorsArray.length; i++) {
                    if (html.indexOf(errorsArray[i]) < 0) {
                        html += '<li>' + errorsArray[i] + '</li>';
                    }
                }
                html += '</ul></div>';
                self.CurrentErrors = errorsArray;

                if (!_firstRun || show) {
                    ele.html(html);
                    self.ScrollToErrors();
                } else {
                    _firstRun = false;
                }

            } else if (!_firstRun || show) {
                var ele = getErrorElement();
                ele.html('');
                self.CurrentErrors = [];
            }
        };
    };
    var _dtmShoppingCart = new DtmShoppingCart();

   <%
    if (enableToggleShippingFields)
    { %>
    //Disable and hide Shipping checkbox if isMultipay = true
    function toggleShippingFields(isMultipay) {
        let shippingCbx = $("[name='ShippingIsDifferentThanBilling']:checkbox");
        let shippingLabel = $("#ShippingIsSame");
        if (!shippingLabel) {
            shippingLabel = shippingCbx.parent().parent();
        }

        if (isMultipay) {
            if (shippingCbx.is(":checked")) {
                shippingCbx.prop("checked", false);
                toggleShipping();
            }
            shippingCbx.prop("disabled", true);
            shippingLabel.hide();
        } else if ($('#otCARD').length == 0 || $('#otCARD').is(':checked')) {
            shippingCbx.prop("disabled", false);
            shippingLabel.show();
        }

    }


    registerEvent("PaymentOptionSelected", function () {
        if (_dtmShoppingCart) {
            toggleShippingFields(_dtmShoppingCart.HasMultipay);
        }
    });

    <%}%>

</script>
<%} %>
