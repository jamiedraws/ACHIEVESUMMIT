<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<script type="text/javascript">

    var verifyBCountry = false;
    var verifySStreet = false;
    var verifySCity = false;
    var verifySState = false;
    var verifySCountry = false;
    var verifyPhone = false;

    var $BillingFirstName = $('#BillingFirstName');
    var $BillingLastName = $('#BillingLastName');
    var $Email = $('#Email');
    var $Phone = $('#Phone');

    var __init_vse = false;

    function onFormPostValidation(event) {
        let errors = [];
        const terms = document.getElementById("TermsCbx");

        if (isEmpty("BillingFirstName")) {
            $BillingFirstName.addClass('has-error');
        } else {
            $BillingFirstName.removeClass('has-error');
        }

        if (isEmpty("BillingLastName")) {
            $BillingLastName.addClass('has-error');
        } else {
            $BillingLastName.removeClass('has-error');
        }

        if (isEmpty("Email")) {
            $Email.addClass('has-error');
        } else {
            $Email.removeClass('has-error');
        }

        if (isEmpty("Phone")) {
            errors.push("Phone is required");
            $Phone.addClass('has-error');
        } else {
            let phone = $Phone.val().replace(/[^0-9]/g, "");
            
            if (phone.length != 10) {
                errors.push("Phone is invalid. Please enter a phone number in the format ###-###-####");
                $Phone.addClass('has-error');
            } else {
                $Phone.removeClass('has-error');
            }
        }

        if (!terms.checked) {
            errors.push("Please agree to the terms of service");
        }

        if ( !__init_vse ) {
            __init_vse = true;
        }

        return errors;
    }

    function isEmpty(fieldId) {
        var value = $('#' + fieldId).val();

        if (value == null) return true;
        var str = value.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
        return str.length == 0;
    }

    (function () {
        var $document = $(document);
        var $acceptOfferButton = $('#AcceptOfferButton');

        $document.ready(function () {
            $acceptOfferButton.on('click', validateForm);
        });
    })();
</script>