<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce.Repositories" %>

<%
    var displayApplicationExtension = SettingsManager.ContextSettings["Seminar.RootLinks.DisplayExtension", true];
    var enableLeadForm = SettingsManager.ContextSettings["Seminar.Template.LeadForm.Enable--LeadForm--", false];
    var partialsType = "ClientSiteViewData";
    var type = Model.GetType();
    var seminarRepo = new SeminarRepository(EcommerceDataContextManager.Current);
    var results = seminarRepo.GetSeminarLocations(DtmContext.CampaignCode);
%>

<% 
    foreach (var result in results) {
        var offer = DtmContext.CampaignOfferVersions.Where(co => co.OfferId == result.CampaignOfferId).FirstOrDefault();
        var product = DtmContext.CampaignProducts.Where(cp => cp.CampaignOfferCodes.Contains(offer.OfferCode)).FirstOrDefault();
        var key = string.Format("Seminar.SeminarTimeByProduct|{0}", product.ProductCode);
        var seminarTime = HttpContext.Current.Cache[key] as SeminarTimeData;
        if(seminarTime == null)
        {
            seminarTime = seminarRepo.GetSeminarTimeByProductCode(product.ProductCode, offer.OfferVersionId);
            HttpContext.Current.Cache[key] = seminarTime;
        }

%>

    <% if (offer != null && offer.OfferCode != DtmContext.OfferCode ) { %>
        <div itemprop="location" itemscope itemtype="http://schema.org/Place">
            <meta itemprop="name" content="<%= offer.OfferName %>">
            <meta itemprop="url" content="https://<%= DtmContext.Domain.Domain %>/<%= offer.OfferCode %>/<%= offer.VersionNumber %>/Index<%= displayApplicationExtension ? DtmContext.ApplicationExtension : string.Empty %>">
            <a class="seminar__rect seminar__rect--link" href="javascript:redirect('/?o=<%= offer.OfferCode.ToUpper() %>');" title="Click to see locations for <%= offer.OfferCode %>">
                <%= offer.OfferCode %>, <%=seminarTime.State %> &middot; <%=seminarTime.SeminarFriendlyName %>
            </a>
        </div>
    <% } %>
<% } %>

<% if (enableLeadForm) {%>

<%
    // displays lead form
    var leadForm = "LeadForm";
    if ( ViewEngines.Engines.FindPartialView(ViewContext.Controller.ControllerContext, leadForm).View != null ) {
        if(string.Equals(type.Name, partialsType) || (type.BaseType != null && string.Equals(type.BaseType.Name, partialsType)))
        {
            Html.RenderPartial(leadForm, Model);
        }
    }
%>

<%}%>
<script>
    function redirect(url) {
        var s = window.location.href.split('?');
        var query = '';
        var regex = '<%= SettingsManager.ContextSettings["Seminar.UrlParameterFilter"] ?? "(o)" %>';

        try {
            regex = RegExp(regex, 'i');
        } catch (e) {

        }

        if (s[1] != undefined) {
            var qs = s[1].split('&');
            $(qs).each(function (index, value) {
                if (!regex.test(value)) {
                    query += value + '&';
                }
            });
        }

        query = query.substring(0, query.length - 1);
        var q = query != null && query != '' ? (url.indexOf('?') < 0 ? '?' : '&') + query : '';

        window.location = url + q;
    }
</script>