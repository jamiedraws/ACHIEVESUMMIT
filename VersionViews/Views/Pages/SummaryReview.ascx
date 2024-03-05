<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.ClientSites.Web.ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var summaryTablePartialName = SettingsManager.ContextSettings["SummaryReviewTable.PartialName", "SummaryReviewTable"];
    var changeText = SettingsManager.ContextSettings["SummaryReviewTable.RemoveUpsells.ChangeOrderButtonText", false];
    var Text = SettingsManager.ContextSettings["SummaryReviewTable.RemoveUpsells.NewOrderButtonText", "Continue to Order Confirmation"];

    var showRebuttalTable = SettingsManager.ContextSettings["SummaryReviewTable.ShowRebuttalTable", false] && DtmContext.PageCode == "OrderSummaryWithEdit";
    var showReOfferTable = SettingsManager.ContextSettings["SummaryReviewTable.ShowReOfferTable", false] && DtmContext.PageCode == "OrderSummaryWithEdit";

    var orderActions = DtmContext.IsMainOfferComplete
               ? DtmContext.Order.Actions
                   .Select(a => new { a.CampaignProductId, a.OfferResponse, a.PageId, a.AddDate })
                   .ToList()
               : DtmContext.Order.OrderActions
                   .Select(a => new { a.CampaignProductId, a.OfferResponse, a.PageId, a.AddDate })
                   .ToList();

    string[] upgradedFrom = { "" };
    string[] downgradedFrom = { "" };

    var orderItems = Model.Order.VisibleOrderItems.ToList();

    var originalProductCodes = orderItems
        .Select(og =>
        {
            var parentProduct = DtmContext.CampaignProducts.FirstOrDefault(cp => cp.RelatedProducts.Any(rp => rp.IsLineItem && rp.CampaignProductId == og.CampaignProductId));
            var currentProductCode = og.CachedProductInfo.ProductCode;
            if (parentProduct != null) //if item is line item, then use parent's product code
                currentProductCode = parentProduct.ProductCode;

            return currentProductCode;
        })
       .Distinct()
       .ToArray();
%>
<%= Html.Partial(summaryTablePartialName, new ViewDataDictionary { { "OriginalItems", string.Join(",", originalProductCodes) }, { "CartItems", string.Join(",", originalProductCodes) }, {"orderCodes", ViewData["orderCodes"] } }) %>

<div class="u-mar--vert @x2-mar"></div>

<% if (showRebuttalTable)
    {
        Html.RenderPartial("RebuttalTable");
    }
    if(showReOfferTable)
    {
        Html.RenderPartial("ReOfferTable");
    }
   %>

<link href="/Shared/facebox/facebox.css" rel="stylesheet" type="text/css" />
<script src="/Shared/facebox/facebox.js" type="text/javascript"></script>
<script type="text/javascript">

    var __cartItems = "<%=string.Join(",", originalProductCodes)%>".split(',');
    var __ogItems = "<%=string.Join(",", originalProductCodes)%>".split(',');
    var __upFrom = "<%=string.Join(",", upgradedFrom)%>".split(',');
    var __downFrom = "<%=string.Join(",", downgradedFrom)%>".split(',');
    var origText = $("input[name='acceptOffer']").val();
    var origDisclaimer = $("#updateSection").children("p").text();
    var focusedElement;
    const cartParamPrefix = "summaryCartParam_";

    function Update(itemId, quantity, item) {
        $.facebox('<h1>Updating...</h1>');
        var downgradeOpts = getCheckboxOptions('downgradeTo_', itemId);
        var upgradeOpts = getCheckboxOptions('upgradeTo_', itemId);
        var removeWith = $('#RemoveBox_' + itemId) != null && $('#RemoveBox_' + itemId).data('removewith') != null ? $('#RemoveBox_' + itemId).data('removewith') : '';
        focusedElement = item;

        let payload = {
            pid: '<%=DtmContext.PageCode%>',
            itemId: itemId,
            quantity: quantity,
            useOM: true,
            OriginalItems: __ogItems.join(','),
            CartItems: __cartItems.join(','),
            UpFrom: __upFrom.join(','),
            DowngradedFrom: __downFrom.join(','),
            renderHtml: true,
            doDowngrade: downgradeOpts.takeAction,
            downgradeFrom: downgradeOpts.from,
            downgradeTo: downgradeOpts.to,
            doUpgrade: upgradeOpts.takeAction,
            upgradeFrom: upgradeOpts.from,
            upgradeTo: upgradeOpts.to,
            doRemove: removeWith.length != '',
            orderCodes: getOrderCodes()
        };

        $(".summaryCartParam").each(function (i, v) {
            let $ele = $(v);
            let type = $ele.attr('type');
            let value = '';

            if ('radio'.indexOf(type) >= 0) {
                value = $('[name=' + v.name + ']:checked').val();
            }
            else if ('checkbox'.indexOf(type) >= 0) {
                value = $('[name=' + v.name + ']').is(':checked');
            }
            else {
                value = $ele.val();
            }

            if (payload[cartParamPrefix + v.name] == null || payload[cartParamPrefix + v.name] == '') {
                payload[cartParamPrefix + v.name] = value
            }

        });

        $.ajax({
            url: "/SetQty",
            data: payload,
            success: function (data) {
                // check if new template is being used
                if ($('html').hasClass('dtm')) {
                    try {
                        // get jQuery version of DOM frag
                        var $data = $(data);
                        // get oswe table
                        var oswe = $data.find('.orderItemsTable');
                        var select = oswe.find('select');

                        // add framework classes back
                        oswe.addClass(_dtm.css.config.OSWE.css);
                        select.addClass(_dtm.css.config.select.css);

                        // check if view is mobile
                        if (Model.IsMobile) {
                            oswe.removeClass(_dtm.remove.config.orderReview.css);
                            // restyle table
                            _dtm.update.setResponsiveTable(oswe, {
                                isReverted: _dtm.settings.revertOFRT,
                                numberOfColumns: _dtm.ShoppingCart.numberOfColumns
                            });
                        }

                        // add updated frag back into DOM
                        $('#orderItemsPlaceholder').html($data);

                    } catch (error) {
                        console.log(error.message + ' because framework JS is not enabled.');
                        // add original frag back into DOM
                        $('#orderItemsPlaceholder').html(data);
                    }

                    finally {
                         <% if (changeText)
    {%>
                        changeText(origText, origDisclaimer);
                        <%}%>

                        if (typeof _dtm.AddFancyboxClass == "function") {
                            _dtm.AddFancyboxClass();
                        }
                    }
                    // new template is not being used so...
                } else {
                    // add original frag back into DOM
                    $('#orderItemsPlaceholder').html(data);
                     <% if (changeText)
    {%>
                    changeText(origText, origDisclaimer);
                        <%}%>
                }

                callback();
                if (typeof (triggerEvent) === 'function') {
                    triggerEvent("SummaryCartUpdated", data);
                }
                $.facebox.close();
            },
            error: function (data) {
                console.log(data);
                $.facebox.close();
                alert('Unable to process, please try again!');
            }
        });
    }

    function getOrderCodes() {

        var orderCodes =
            $.map($('[name^="OC_"][type="text"]'), function (i) {

                return i.name + '=' + i.value;

            });

        return orderCodes.join('&');

    }

    function callback()
    {
        if (focusedElement && focusedElement.id) {
            var element = document.getElementById(focusedElement.id);
            if (element != undefined)
                element.focus();
        }
    }

    function getCheckboxOptions(target, itemId) {
        var hasOption = $('[name="' + target + itemId + '"]').length != 0;
        var result = {
            hasOption: hasOption,
            checkbox: $('[name="' + target + itemId + '"]'),
            from: hasOption ? $('[name="' + target + itemId + '"]').attr('data-from') : '',
            to: hasOption ? $('[name="' + target + itemId + '"]:checked').val() : '',
            changeWith: hasOption ? $('[name="' + target + itemId + '"]').attr('data-changewith') : '',
            removeWith: hasOption ? $('[name="' + target + itemId + '"]').attr('data-removewith') : '',
            takeAction: hasOption && $('[name="' + target + itemId + '"]').is(':checked'),
            action: hasOption ? $('[name="' + target + itemId + '"]').attr('data-action') : ''
        };

        if (result.takeAction) {
            updateItemList(result);
        }

        return result;
    }

    function updateItemList(result) {
        var changeWith = result.changeWith;
        if (changeWith != null && typeof changeWith == "string" && changeWith.length > 0) {
            var changeWithOptions = changeWith.split(',');
            for (var i = 0; i < changeWithOptions.length; i++) {
                var currentOption = changeWithOptions[i];
                for (var j = 0; j < __cartItems.length; j++) {
                    var currentItem = __cartItems[j];
                    if (currentOption == currentItem) {
                        var newOptionValue;
                        switch (result.action) {
                            case "downgrade":
                                newOptionValue = $('[data-from="' + currentOption + '"][name*="downgradeTo"]').val() == undefined
                                    ? currentOption
                                    : $('[data-from="' + currentOption + '"][name*="downgradeTo"]').val();
                                break;
                            case "upgrade":
                                newOptionValue = $('[data-from="' + currentOption + '"][name*="upgradeTo"]').val() == undefined
                                    ? currentOption
                                    : $('[data-from="' + currentOption + '"][name*="upgradeTo"]').val();
                                break;
                            default:
                                newOptionValue = $('[data-from="' + currentOption + '"]').length > 1
                                    ? $('[data-from="' + currentOption + '"]:checked').val()
                                    : $('[data-from="' + currentOption + '"]').val();
                                break;
                        }
                        __cartItems[j] = newOptionValue;
                    }
                }
            }
        }
    }


     <% if (changeText)
    {%>
    $(document).ready(function () {


        //$("#orderReviewTable").on("change", "select[name*='ActionQuantity']", { trigger: this, includeHidden: false, oText: origText, oDisclaimer: origDisclaimer }, changeText);
        //$("#orderReviewTable").on("change", "input[name*='ActionQuantity'], input[name*='RemoveBox'], input[name*='AddBox']", { trigger: this, includeHidden: true, oText: origText, oDisclaimer: origDisclaimer }, changeText);
    });

    function changeText(oText, oDisclaimer) {

        var upsellQty = 0;
       
        $("#orderReviewTable").find("select[pType=Upsell], input[pType=Upsell]").each(function () {
            var actionQty = $(this).attr("name");
            var dataFrom = $(this).attr("data-from");
            var index = actionQty.substring(actionQty.length - 1, actionQty.length);
            var value = $("#ActionCode" + index).val();
            var qty = "";
            var gskuRegex = new RegExp(/^(.*)[_]LI\d+$/i);
            if (gskuRegex.test(value || '')) {
                value = (gskuRegex.exec(value) || ['', ''])[1];
            }
            qty = $(this).val();

            if (dataFrom != undefined) {
                var actionCode = $("[value='" + dataFrom + "']").attr("name");
                index = actionCode.substring(actionQty.length - 1, actionQty.length);
                value = dataFrom;
                qty = $("#ActionQuantity" + index).val();
            }
           
            upsellQty += parseInt(qty);
          
        });
        if (upsellQty <= 0) {
            $("input[name='acceptOffer']").val("<%=Text%>");
            $("#updateSection_bottom, #updateSection").children("p").text(" ");
        } else {
            $("input[name='acceptOffer']").val(oText);
            $("#updateSection_bottom, #updateSection").children("p").text(oDisclaimer);
        }
    }
    <%}%>
</script>
