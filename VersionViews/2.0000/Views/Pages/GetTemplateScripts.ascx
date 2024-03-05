<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<% 
    var eflexGroup = SettingsManager.ContextSettings["FrameworkJS/CSS.Eflex.Group", false];
    var groupSelector = SettingsManager.ContextSettings["FrameworkJS/CSS.Eflex.Group.Selector"];

    var eflexSwap = SettingsManager.ContextSettings["FrameworkJS/CSS.Eflex.Swap", false];
    var swapSelector = SettingsManager.ContextSettings["FrameworkJS/CSS.Eflex.Swap.Selector"];

    var FormType = SettingsManager.ContextSettings["Seminar.Template.Form.FormType--Form--", string.Empty];
    var PartialPrefix = "FormJS-";
    var PartialName = PartialPrefix + FormType.Replace(" ", "-");

    var ScriptName = "GetVersionScripts";
    var CustomerScriptName = "GetCustomerScripts";

    var locations = Model != null ? Model.Locations : null;
    var allSeminars = locations != null ? locations.AllSeminars : null;
    var seminars = allSeminars ?? new List<Dtm.Framework.ClientSites.Web.Models.SeminarDateViewData>();
    var hasOnlyOneTime = seminars.Sum(s => s.SeminarTimes == null ? 0 : s.SeminarTimes.Count()) == 1;

    if (DtmContext.Page.IsStartPageType)
    {
        if (ViewEngines.Engines.FindPartialView(ViewContext.Controller.ControllerContext, PartialName).View != null)
        {
            Html.RenderPartial(PartialName, Model);
        }
        else
        {
            Html.RenderPartial("FormJS-US-Short", Model);
        }
    }
    //else
    //{
    //    Html.RenderPartial("PrintTicket");
    //}

    Html.RenderPartial("CampaignTestimonials");
%>
<script src="/shared/js/moment.min.js"></script>
<script>
    (function () {
        // get window
        var $window = $(window);
        // get document 
        var $document = $(document);
        // get html
        var $html = $('html');
        // get seminar 
        var $seminar = $('#register');
        // get seminar radio input
        var $seminar__radio = $seminar.find('.c-brand--seminar__radio input[name="ActionCode0"]');
        // get validation errors
        var $vse = $('.validation-summary-errors');


        // check when user has interacted with the page
        var userInitiated = false;

        // set ready object
        var ready = {
            vimeo: false, youtube: false
        };

        // when framework js is ready
        $html.on('dtm/vimeo', function () {
            // enable responsive vimeo video
            _dtm.makeVimeoResponsive({
                scaleByElement: $('[data-eflex-scale-vimeo-custom]'),
                onAfter: function (self) {
                    // check if vimeo is ready to be displayed
                    if (!ready.vimeo) {
                        self.scale.addClass('vimeo-is-ready');
                        ready.vimeo = true;
                    }
                }
            });
        });

        // when framework js is ready
        $html.on('dtm/youtube', function () {
            // enable responsive youtube video
            _dtm.makeYouTubeResponsive({
                scaleByElement: $('[data-eflex-scale-youtube-custom]'),
                onAfter: function (self) {
                    // check if youtube is ready to be displayed
                    if (!ready.youtube) {
                        self.scale.addClass('youtube-is-ready');
                        ready.youtube = true;
                    }
                }
            });
        });

        // when the page loads, scroll to the confirmation message
        $window.load(function () {
            <% if (!DtmContext.Page.IsStartPageType)
    { %>
            $.scrollTo($seminar, 100);
            <% }
    else
    { %>
            if ($vse.is(':visible')) $.scrollTo($vse, 100);
            <% } %>
        });

        <% if (eflexGroup)
    { %>

        $('<%= groupSelector %>').on('eflex/group/onAfter', function (eflex) {
            eflex.self.el.addClass('form__event--is-visible');
        });

        <% } %>

        <% if (eflexSwap && hasOnlyOneTime)
    { %>
        $('<%= swapSelector %>').on('eflex/swap/onInit', function (eflex) {
            console.log("This seminar only has one date/one time");
            eflex.self.isVisible = true;
            eflex.self.freeze = true;
        });
        <% } %>

        // ADA action : set tabluation onto the errors
        _dtm.callbackAlert = function (errors, $vse) {
            if ($vse.find('.screen-reader-only').length === 0) {
                $('<span/>', {
                    tabindex: 0,
                    class: 'screen-reader-only',
                    html: errors
                }).prependTo($vse);
            }
            $vse.find('.screen-reader-only').focus();
        };

        $seminar__radio.eflex('draw');

        $document.ready(function () {
            const is_uiwebview = /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(navigator.userAgent);

            if (is_uiwebview) {
                $('#ocal').addClass('hide');
                $('[href^="/Shared/Services/AppointmentService.ashx"]').addClass('cal--is-disabled');
            }

            $('#calReminder').on('click', function () {
                $('#calType').removeClass('@js-only-hide');
            });

            <% if (DtmContext.Page.PageCode.ToLower() != "vip")
    {%>
            //Checking to see if event date has expired
            $('[name=ActionCode0]').each(function (idx, element) {
                var id = $(element).attr('id');
                var timeText = id.replace("ActionCode", "ActionTimeLabel")
                var timeLabel = $(element).parent('label');

                var timeString = typeof $(element).data('fulltime') !== "undefined" ? $(element).data('fulltime') : null;
                var timeNow = moment().toDate();

                if (timeString !== null) {
                    var timeOfEvent = moment(timeString).toDate();

                    if (timeNow > timeOfEvent) {
                        $('#' + timeText).append('-Registration for this event has ended');
                        $('#' + timeText).css('color', 'red');
                        $(element).parent('span').remove();
                    }
                }

            });
            <%}%>
        });

        <%
    if (ViewEngines.Engines.FindPartialView(ViewContext.Controller.ControllerContext, CustomerScriptName).View != null)
    {
        Html.RenderPartial(CustomerScriptName, Model);
    }

    if (ViewEngines.Engines.FindPartialView(ViewContext.Controller.ControllerContext, ScriptName).View != null)
    {
        Html.RenderPartial(ScriptName, Model);
    }
        %>

    })();
</script>

<%= Model.FrameworkVersion %>

<div class="l-controls">
    <% Html.RenderSiteControls(SiteControlLocation.ContentTop); %>
    <% Html.RenderSiteControls(SiteControlLocation.ContentBottom); %>
    <% Html.RenderSiteControls(SiteControlLocation.PageBottom); %>
    <% if (DtmContext.Page.IsStartPageType)
        { %>
    <div class="hide">
        <%= Html.Partial("SocialPlugins") %>
    </div>
    <% } %>
</div>
