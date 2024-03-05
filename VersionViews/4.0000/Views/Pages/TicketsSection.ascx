<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%
    var viewData = new ViewDataDictionary();

    if (DtmContext.IsMobile)
    {
        viewData.Add("ShowImage", false);
        viewData.Add("ShowPerks", false);
        viewData.Add("ShowSeatingChart", true);
%>
<link rel="stylesheet" href="/css/ticket-condensed.css?v=1">
<%
    }
    Html.RenderPartial("_Tickets", Model, viewData);
%>
