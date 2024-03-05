<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>

<style>
    .ticket__callout {
        display: none;
    }
</style>
<% Html.RenderPartial("_Tickets", Model); %>