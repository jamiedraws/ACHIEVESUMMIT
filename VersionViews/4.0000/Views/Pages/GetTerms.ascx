<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var termsURL = SettingsManager.ContextSettings["Seminar.Template.Policy.TermsOfUse--Policy--", string.Empty];
    var termsText = SettingsManager.ContextSettings["Seminar.Template.Policy.TermsOfUseText--Policy--", string.Empty];
    var termsTitle = SettingsManager.ContextSettings["Seminar.Template.Policy.TermsOfUseTitle--Policy--", string.Empty];
%>

<% if ( !String.IsNullOrEmpty(termsURL) ) { %>
    <a class="has-fancybox fancybox.iframe" data-fancybox-method="page" href="<%= termsURL.Replace("[#ext#]", DtmContext.ApplicationExtension) %>" title="<%= termsTitle %>" class="has-fancybox fancybox.iframe"><%= termsText %></a>
<% } %>