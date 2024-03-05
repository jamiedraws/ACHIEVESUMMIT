using System;
using System.Text.RegularExpressions;
using Dtm.Framework.ClientSites.Web;
using System.Web.Mvc;
using System.Collections.Specialized;
using Dtm.Framework.Services.DtmApi;

namespace ACHIEVESUMMIT.Models.Interfaces
{
    public interface ILocationEngine
    {
        ModelStateDictionary GetModelErrors(ModelStateDictionary modelState, NameValueCollection form, SafeDictionary postData);
    }
}