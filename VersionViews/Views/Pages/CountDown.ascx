<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<% 
    var location = Model.Locations.AllSeminars.FirstOrDefault();
    if (location != null)
    {
        var time = location.SeminarTimes.FirstOrDefault();
        if (time != null)
        {
            var hours = time.Time / 100;
            var mins = time.Time % 100;
            var seminarDate = location.SeminarDate.AddHours(hours).AddMinutes(mins);
%>
<div class="countdown">
    <span class="countdown__item">
        <span id="countdown__day">00</span>
        <small>Days</small>
    </span>
    <div class="countdown__item">
        <span>:</span>
    </div>
    <span class="countdown__item">
        <span id="countdown__hour">00</span>
        <small>Hrs</small>
    </span>
    <div class="countdown__item">
        <span>:</span>
    </div>
    <span class="countdown__item">
        <span id="countdown__min">00</span>
        <small>Min</small>
    </span>
    <div class="countdown__item">
        <span>:</span>
    </div>
    <span class="countdown__item">
        <span id="countdown__sec">00</span>
        <small>Sec</small>
    </span>
</div>
<script defer src="/shared/js/moment.min.js"></script>
<script defer src="/js/CountDown.js"></script>
<script>
    const dayId = "countdown__day";
    const hourId = "countdown__hour";
    const minId = "countdown__min";
    const secId = "countdown__sec";
    document.addEventListener("DOMContentLoaded", function () {

        let date = new Date(<%=seminarDate.Year%>, <%=seminarDate.Month%> - 1, <%=seminarDate.Day%>)
        let expired = moment().startOf('day') >= date;
        if (!expired) {
            _countDownEngine.setCountdown({
                date: date,
                onInit: function (_this) {
                    document.getElementById(dayId).innerHTML = _this.watch.days;
                    document.getElementById(hourId).innerHTML = _this.watch.hours;
                    document.getElementById(minId).innerHTML = _this.watch.minutes;
                    document.getElementById(secId).innerHTML = _this.watch.seconds;

                },
                onCount: function (data) {
                    document.getElementById(dayId).innerHTML = data.time.days;
                    document.getElementById(hourId).innerHTML = data.time.hours;
                    document.getElementById(minId).innerHTML = data.time.minutes;
                    document.getElementById(secId).innerHTML = data.time.seconds;
                }
            });
        } else {
            console.log('Countdown Expired');
        }
        
    });
</script>
<%

        }
    }

%>