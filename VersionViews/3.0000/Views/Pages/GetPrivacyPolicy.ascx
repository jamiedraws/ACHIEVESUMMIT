<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var privacyPolicyURL = SettingsManager.ContextSettings["Seminar.Template.Policy.PrivacyPolicy--Policy--", string.Empty];
    var privacyPolicyText = SettingsManager.ContextSettings["Seminar.Template.Policy.PrivacyPolicyText--Policy--", string.Empty];
    var privacyPolicyTitle = SettingsManager.ContextSettings["Seminar.Template.Policy.PrivacyPolicyTitle--Policy--", string.Empty];
%>

<% if ( !String.IsNullOrEmpty(privacyPolicyURL) ) { %>
    <a class="has-fancybox fancybox.iframe" data-fancybox-method="page" href="<%= privacyPolicyURL.Replace("[#ext#]", DtmContext.ApplicationExtension) %>" title="<%= privacyPolicyTitle %>" class="has-fancybox fancybox.iframe"><%= privacyPolicyText %></a>
<% } %>