var SummaryReviewCartEngine = function(){
    const selectedClass = 'is-selected';
    const fromAttr = 'data-from';
    const toAttr = 'data-to';
    const actionAttr = 'data-action';
    const codeAttr = 'data-code';
    const qtyEleAttr = 'data-qty-ele';
    const styleAttr = "style";
    const $fromEle = $("#actionFrom");
    const $toEle = $("#actionTo");
    const $actionEle = $("#action");
    const downgradeAction = "downgrade";
    const upgradeAction = "upgrade";
    const addAction = "add";
    const removeAction = "remove";
    const disabledStyle = "background-color:#c0c0c0;pointer-events:none;";
    const self = this;
    this.dataFromSelector = '[' + fromAttr + ']';
    this.dataCodeSelector = '[' + codeAttr +']';

    this.Upgrade = function () {
        const $self = $(this);
        const from = $self.attr(fromAttr);
        const code = $self.attr(toAttr);
        const action = $self.attr(actionAttr);
        const $addBtn = $(".add" + code);
        let qty = 1; 
        let actionCode = '';

        if (action === 'upgrade') {
            $fromEle.val(from);
            $toEle.val(code);
            qty = GetQty(from);
            actionCode = from;
            if ($addBtn) {
                $addBtn.hide();
            }
        } else {
            $fromEle.val(code);
            $toEle.val(from);
            qty = GetQty(code);
            actionCode = code;
            if ($addBtn) {
                $addBtn.show();
            }
        }

        $actionEle.val(action);
        Update(actionCode, qty, $self);
    };

    this.AddToCart = function () {
        const $self = $(this);
        const code = $self.attr(codeAttr);
        const action = $self.attr(actionAttr);
        const qtyId = "#" + $self.attr(qtyEleAttr);
        const $upgradeBtn = $(".upgrade" + code);

        if (action === 'remove') {
            if (__cartItems.indexOf(code) >= 0) {
                __cartItems = __cartItems.filter(function (value) { return value !== code; });
            } 
            if ($upgradeBtn) {
                $upgradeBtn.show();
            }
           
            Update(code, 0, $self);
        } else {
            if (__cartItems.indexOf(code) < 0) {
                __cartItems.push(code);
            } 
            if ($upgradeBtn) {
                $upgradeBtn.hide();
            }
            Update(code, parseInt($(qtyId).val()), $self);
        }

    };

    this.UpdateState = function () {
        $(self.dataFromSelector + "," + self.dataCodeSelector).each(function (i, v) {
            const $ele = $(v);
            let code = "";

            if ($ele.attr(toAttr)) {
                code = $ele.attr(toAttr);
            }else if ($ele.attr(codeAttr)) {
                code = $ele.attr(codeAttr);
            }
            const $addBtn = $(".add" + code);

            if (__cartItems.indexOf(code) >= 0) {
                let qty = GetQty(code);
                
                $addBtn.hide();
                if (qty > 0) {
                    UpdateItemState($ele, true, qty);
                } else {
                    UpdateItemState($ele, false, 1);
                }
            } else {
                $addBtn.show();
                UpdateItemState($ele, false, 1);
            }
        });

        $(".summaryCartParam").val("");
    };

    var UpdateItemState = function ($ele, exists, qty) {
        if ($ele[0].type && $ele[0].type === 'checkbox') {
            UpdateCheckboxState($ele, exists);
        } else {
            UpdateBtnState($ele, exists, qty);
        }
    };

    var UpdateCheckboxState = function ($ele, exists) {
        if (exists) {
            $ele.prop("checked", true);
        } else {
            $ele.prop("checked", false);
        }
    };

    var UpdateBtnState = function ($ele, exists, qty) {
        if (exists) {
            $ele.addClass(selectedClass);

            if ($ele.attr(actionAttr) === upgradeAction) {
                $ele.html("Downgrade Tickets");
                $ele.attr(actionAttr, downgradeAction);
                if (__cartItems.indexOf($ele.attr(fromAttr)) < 0) {
                    $(self.dataFromSelector + "[data-to!='" + $ele.attr(toAttr) + "']").attr(styleAttr, disabledStyle);
                }
            } 

           

        } else {
            $ele.removeClass(selectedClass);

            if ($ele.attr(actionAttr) === downgradeAction) {
                $ele.html("Upgrade Tickets");
                $ele.attr(actionAttr, upgradeAction);
                $(self.dataFromSelector).attr(styleAttr, '');
            } else if ($ele.attr(actionAttr) === removeAction) {
                $ele.html("Add To Cart");
                $ele.attr(actionAttr, addAction);
            }
        }
    };

    var GetQty = function (productCode) {
        const index = $("[name*=ActionCode][value='" + productCode + "']").attr("name").replace("ActionCode", "");
        return parseInt($("#ActionQuantity" + index).val());
    };
};

var _summaryReviewCartEngine = new SummaryReviewCartEngine();

$(document).ready(function () {
    _summaryReviewCartEngine.UpdateState();
    $(_summaryReviewCartEngine.dataFromSelector).on("click", _summaryReviewCartEngine.Upgrade);
    $(_summaryReviewCartEngine.dataCodeSelector).on("click", _summaryReviewCartEngine.AddToCart);
});

registerEvent("SummaryCartUpdated", _summaryReviewCartEngine.UpdateState);


