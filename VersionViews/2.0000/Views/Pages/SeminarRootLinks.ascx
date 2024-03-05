<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce.Repositories" %>

<%

    Dictionary<string, string> dates = new Dictionary<string, string>
    {
        {"DENVER, CO", "Tues, Nov. 17, 2020" },
        {"DALLAS, TX", "Mon, Mar. 8, 2021" },
        {"ANAHEIM, CA", "Tues, Dec. 8, 2020" },
        {"FT LAUDERDALE, FL", "Tues, Jan. 19, 2021" },
        {"HOUSTON, TX", "Thurs, Jan. 28, 2021" },
        {"TAMPA, FL", "Wed, Feb. 24, 2021" },
        {"CHICAGO, IL", "Tues, Apr. 13, 2021" },
    };

    foreach (var date in dates.OrderBy(d=> d.Key))
    {
%>
        <a class="seminar__rect seminar__rect--link" href="javascript:void();" title="Click to see locations for Denver" style="pointer-events: none;">
        <%=date.Key %> &middot; <%=date.Value %>
        </a>
<%
    }

%>

    

