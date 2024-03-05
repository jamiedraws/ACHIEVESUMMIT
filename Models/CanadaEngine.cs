using System;
using System.Text.RegularExpressions;
using Dtm.Framework.ClientSites.Web;
using System.Web.Mvc;
using ACHIEVESUMMIT.Models.Interfaces;
using System.Linq;
using System.Collections.Specialized;
using Dtm.Framework.Services.DtmApi;
using Dtm.Framework.ClientSites;
using Dtm.Framework.Extensions;

namespace ACHIEVESUMMIT.Models
{
    public class CanadaEngine : PageHandler, ILocationEngine
    {
        public ModelStateDictionary GetModelErrors(ModelStateDictionary modelState, NameValueCollection form, SafeDictionary postData)
        {
            var seminarTimes = postData.Select(j => j.Value).Sum();
            var formType = SettingsManager.ContextSettings["Seminar.Template.Form.FormType--Form--", "CA-Long"];
            var billingFirstName = form["BillingFirstName"] ?? string.Empty;
            var billingLastName = form["BillingLastName"] ?? string.Empty;
            var billingStreet = form["BillingStreet"] ?? string.Empty;
            var billingZip = form["BillingZip"] ?? string.Empty;
            var billingState = form["BillingState"] ?? string.Empty;
            var billingCity = form["BillingCity"] ?? string.Empty;
            var cellPhone = form["CellPhone"] ?? string.Empty;
            var phone = form["Phone"] ?? string.Empty;
            var email = form["Email"] ?? string.Empty;
            var emailRegex = "^(?:[A-z0-9%&+-]+[.])*[A-z0-9%&+-]+@[A-z0-9.-]+\\.[A-z]{2,6}$";
            string zipRegex = (formType == "CA-Short") ? @"(^\d{5}(?:[-\s]\d{4})?$)|(^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$)" : @"^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$";
            var numbersOnlyRegex = @"[^\d]";
            var numbersOnlyPhoneLength = Regex.Replace(phone, numbersOnlyRegex, string.Empty).Length;

            /* Settings */
            var validateBillingFirstName = SettingsManager.ContextSettings["DTM.ClientSites.ValidateBillingFirstName", true];
            var validateBillingLastName = SettingsManager.ContextSettings["DTM.ClientSites.ValidateBillingLastName", true];
            var validateBillingStreet = SettingsManager.ContextSettings["DTM.ClientSites.ValidateBillingStreet", true];
            var validateBillingCity = SettingsManager.ContextSettings["DTM.ClientSites.ValidateBillingCity", true];
            var validateBillingState = SettingsManager.ContextSettings["DTM.ClientSites.ValidateBillingState", true];
            var validateBillingCountry = SettingsManager.ContextSettings["DTM.ClientSites.ValidateBillingCountry", true];
            var validateBillingZip = SettingsManager.ContextSettings["DTM.ClientSites.ValidateBillingZipEmpty", true];
            var validatePhone = SettingsManager.ContextSettings["DTM.ClientSites.ValidatePhoneNumber", true];
            var validateEmail = SettingsManager.ContextSettings["DTM.ClientSites.ValidateEmail", true];


            if (seminarTimes == 0)
            {
                modelState.AddModelError("Form", "Please select a seminar time.");
            }
            if (String.IsNullOrEmpty(billingFirstName) && validateBillingFirstName)
            {
                modelState.AddModelError("BillingFirstName", "First Name is required");
            }
            if (String.IsNullOrEmpty(billingLastName) && validateBillingLastName)
            {
                modelState.AddModelError("BillingLastName", "Last Name is required");
            }
            if (billingStreet == string.Empty && validateBillingStreet)
            {
                modelState.AddModelError("BillingStreet", "Address is required");
            }

            if (billingState == string.Empty && validateBillingState)
            {
                modelState.AddModelError("BillingState", "State is required");
            }
            if (billingCity == string.Empty && validateBillingCity)
            {
                modelState.AddModelError("BillingCity", "City is required");
            }
            if (String.IsNullOrEmpty(billingZip) && validateBillingZip)
            {
                modelState.AddModelError("BillingZip", "Zip is required");
            }
            else if ((String.IsNullOrEmpty(billingZip) || billingZip.Length == 0 || !Regex.IsMatch(billingZip, zipRegex)) && validateBillingZip)
            {
                modelState.AddModelError("BillingZip", "A valid Postal Code is required");
            }
            if ((String.IsNullOrEmpty(phone) || numbersOnlyPhoneLength != 10) && validatePhone)
            {
                modelState.AddModelError("Phone", "Phone is invalid. Please enter a phone number in the format ###-###-####.");
            }
            if (String.IsNullOrEmpty(email) && validateEmail)
            {
                modelState.AddModelError("Email", "Email is required.");
            }
            else if ((!Regex.IsMatch(email, emailRegex, RegexOptions.IgnoreCase)) && validateEmail)
            {
                modelState.AddModelError("Email", "Email is invalid.");
            }

            if (!string.IsNullOrEmpty(cellPhone))
            {
                if (cellPhone.NumbersOnly().Length != 10)
                    modelState.AddModelError("Cell1", "Please enter in a valid 10 digit cell phone number");
            }

            return modelState;
        }
    }
}