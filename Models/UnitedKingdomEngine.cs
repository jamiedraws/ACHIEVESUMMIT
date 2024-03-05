using System;
using System.Text.RegularExpressions;
using Dtm.Framework.ClientSites.Web;
using System.Web.Mvc;
using ACHIEVESUMMIT.Models.Interfaces;
using System.Linq;
using System.Collections.Specialized;
using Dtm.Framework.Services.DtmApi;

namespace ACHIEVESUMMIT.Models
{
    public class UnitedKingdomEngine : PageHandler, ILocationEngine
    {
        public ModelStateDictionary GetModelErrors(ModelStateDictionary modelState, NameValueCollection form, SafeDictionary postData)
        {
            var seminarTimes = postData.Select(j => j.Value).Sum();
            var billingFirstName = form["BillingFirstName"] ?? string.Empty;
            var billingLastName = form["BillingLastName"] ?? string.Empty;
            var billingStreet = form["BillingStreet"] ?? string.Empty;
            var phone = form["Phone"] ?? string.Empty;
            var email = form["Email"] ?? string.Empty;
            var emailRegex = "^(?:[A-z0-9%&+-]+[.])*[A-z0-9%&+-]+@[A-z0-9.-]+\\.[A-z]{2,6}$";
            var numbersOnlyRegex = @"[^\d]";
            var numbersOnlyPhoneLength = Regex.Replace(phone, numbersOnlyRegex, string.Empty).Length;

            if (seminarTimes == 0)
            {
                modelState.AddModelError("Form", "Please select a seminar time.");
            }
            if (String.IsNullOrEmpty(billingFirstName))
            {
                modelState.AddModelError("BillingFirstName", "First Name is required");
            }
            if (String.IsNullOrEmpty(billingLastName))
            {
                modelState.AddModelError("BillingLastName", "Last Name is required");
            }
            if (String.IsNullOrEmpty(billingStreet))
            {
                modelState.AddModelError("BillingStreet", "Address is required");
            }
            else if (!String.IsNullOrEmpty(phone) || (numbersOnlyPhoneLength < 7 || numbersOnlyPhoneLength > 21))
            {
                modelState.AddModelError("Phone", "Phone is invalid. Please enter a valid phone number.");
            }
            if (String.IsNullOrEmpty(email))
            {
                modelState.AddModelError("Email", "Email is required.");
            }
            else if (!Regex.IsMatch(email, emailRegex, RegexOptions.IgnoreCase))
            {
                modelState.AddModelError("Email", "Email is invalid.");
            }

            return modelState;
        }
    }
}