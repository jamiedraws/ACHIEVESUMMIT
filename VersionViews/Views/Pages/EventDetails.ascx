<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>

<%

    var location = Model.Locations.AllSeminars.FirstOrDefault();

    if (location != null)
    {
        var date = location.SeminarDate;
        var time = location.SeminarTimes.FirstOrDefault();
        if (time != null && time.CampaignProduct != null)
        {
            var openTime = time.CampaignProduct.PropertyIndexer.Has("OpenTime") ? time.CampaignProduct.PropertyIndexer["OpenTime"] : string.Empty;
            var endTime = time.CampaignProduct.PropertyIndexer.Has("EndTime") ? time.CampaignProduct.PropertyIndexer["EndTime"] : string.Empty;
            var seminarTimeZone = time.CampaignProduct.TimeZoneDisplayId;
            var timeZone = !string.IsNullOrWhiteSpace(seminarTimeZone) ? TimeZoneInfo.FindSystemTimeZoneById(seminarTimeZone)
                    : TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");

            var hours = time.Time / 100;
            var mins = time.Time % 100;
            var seminarDate = location.SeminarDate.AddHours(hours).AddMinutes(mins);

%>
    <div class="copy">
        <h2 class="copy__title">Event Details</h2>
        <strong>Location:</strong>
        <address>
            <%=location.SeminarLocation %><br>
            <%=location.Street %><br>
            <%=location.City %>, <%=location.State %> <%=location.Zip %>
        </address>

        <%
            var mapCoords = string.Format("lat={0}&long={1}", location.MapLatitude, location.MapLongitude);
            if (location.MapLatitude == 0 && location.MapLongitude == 0) {
                mapCoords = string.Format("addr={0} {1}, {2} {3}", location.Street, location.City, location.State, location.Zip);
            }
            var mapSrc = "/shared/map.aspx?" + mapCoords;
        %>

        <div class="arp arp--fill copy__frame" style="--arp: 515/281; max-width: 515px" data-src-iframe="<%= mapSrc %>" data-attr='{ "title" : "Event directions", "width" : "515", "height" : "281" }'>
            <noscript>
                <iframe title="Event directions" src="<%= mapSrc %>" frameborder="0" width="515" height="281"></iframe>
            </noscript>
        </div>
        <div class="copy__desc">
        <%
            if (!string.IsNullOrEmpty(openTime))
            {
        %>
        <strong>Registration:</strong>
        <p>The doors will open and registration will begin at <%=openTime %>.</p>
        <%  
            }
        %>
        <strong>Event Date / Start Time:</strong>
        <p>The event is on <%=location.SeminarFriendlyName %>. It will begin at <%=seminarDate.Hour.ToString("##") + seminarDate.ToString("tt", System.Globalization.CultureInfo.InvariantCulture).ToLower() %> <%=timeZone.StandardName  %> <%if (!string.IsNullOrEmpty(endTime)){ %> and end at <%=endTime %> <%} %> <%=timeZone.StandardName  %>.</p>
        </div>
        <nav>
            <a data-fancybox href="#seating" class="button button--view-chart" id="event-seating-chart">View Seating Chart</a>
            <a href="#ticket" class="button" id="event-tickets">Buy Tickets</a>
        </nav>
    </div>
<%

        }
    }
%>