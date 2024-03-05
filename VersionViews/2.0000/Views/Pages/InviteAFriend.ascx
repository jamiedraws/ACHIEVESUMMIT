<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce" %>

<%
	var CampaignName = SettingsManager.ContextSettings["Label.ProductName"];

	var showFormOnPageLoad = SettingsManager.ContextSettings["InviteAGuest.ShowFormOnPageLoad", false];
	var showHeaderImage = SettingsManager.ContextSettings["InviteAGuest.ShowHeaderImage", false];
	
	var inviteHeaderImage = SettingsManager.ContextSettings["Email.HeaderImage", string.Empty];
	var inviteHeadline = SettingsManager.ContextSettings["InviteAGuest.Headline", "Tell your friends about attending"];
	var inviteSubheadline = SettingsManager.ContextSettings["InviteAGuest.Subheadline", "a Free Live Wealth Building Event!"];
	
	var inviteDescription = SettingsManager.ContextSettings["InviteAGuest.Description", "We'll send your friend an e-mail telling them about this event."];
	var inviteEmailTempPath = SettingsManager.ContextSettings["InviteAGuest.EmailTemplatePath", "/email/1/Invite"];
	var inviteSuccessMessage =  SettingsManager.ContextSettings["InviteAGuest.SuccessMessage", "Email sent!"];
	var inviteSuccessHeadline = SettingsManager.ContextSettings["InviteAGuest.SuccessHeadline", "Thank you!"];

	var inviteValidationStartEffect = SettingsManager.ContextSettings["InviteAGuest.ValidationStartEffect", "show"];
	var inviteValidationDuration = SettingsManager.ContextSettings["InviteAGuest.ValidationDuration", 400];
	var inviteValidationEasing = SettingsManager.ContextSettings["InviteAGuest.ValidationEasing", "swing"];

    var nameValidationRegex = SettingsManager.ContextSettings["Validation.ValidateNameRegexPattern", "^[a-zA-Z ,.\\-']{1,}[a-zA-Z ,.\\-']*$"];
%>

	<style>
		/* allow success message to expand: TODO update animation to use CSS transitions instead of jQuery */
		.c-brand--invite .o-box--msg-success {
			display: block !important;
		}
	</style>

	<!-- // Invite A Guest HTML Form -->
	<div id="invite-friend" data-fancybox-after-close="invite-friend" class="hide dtm <%= Model.IsMobile ? "@mv" : "@dv" %>">

		<div class="dtm__in no-background <%= Model.IsMobile ? "dtm__in--mv" : "dtm__in--dv" %>">

			<div class="c-brand c-brand--invite">		
				<form id="inviteForm" class="c-brand--form">
		
					<%= Html.Hidden("oid", DtmContext.OrderId) %>
					<%= Html.Hidden("r", ViewData["ReferURL"]) %>
					<%= Html.Hidden("mode", "ajax") %>
					<%= Html.Hidden("t", inviteEmailTempPath) %>
                    <%= Html.Hidden("f", DtmContext.Domain.Domain) %>
		
					<div tabindex="0" class="invite__header">
						<% if ( !String.IsNullOrEmpty(inviteHeaderImage) && showHeaderImage ) { %>
							<!-- // Thumbnail -->
							<img class="block" src="<%= inviteHeaderImage %>?v=<%= DtmContext.ApplicationVersion %>" alt="<%= CampaignName %>">
						<% } %>
	
						<!-- // Headline -->
						<h3 data-invite-headline class="c-brand--box c-brand__headline--box o-box--block u-mar fn--strong"><%= inviteHeadline %></h3>
			
						<div data-invite-message class="u-pad--horz fn--center u-mar--top">
							<!-- // Subheadline -->
							<h3 class="fn--center c-brand__headline"><%= inviteSubheadline %></h3>
							<!-- // Description -->
							<p class="u-mar--reset"><%= inviteDescription %></p>
						</div>
					</div>
		
					<fieldset class="c-brand--form__fieldset--borderless">
		
						<hr class="c-brand--form__hr">
		
						<ul class="c-brand--form__list c-brand--form__borderless u-pad">
		
							<!-- // Message Container -->
							<li id="resultCt" class="c-brand--invite__content invite__vse" data-invite-content="feedback">
								<span id="result" data-result><%= ViewData["Result"] %></span>
							</li>
		
							<li id="inputCt" data-fieldset>
		
								<ul class="c-list--reset">
		
									<!-- // First Name -->
									<li id="MyFirstNameCt" class="c-brand--form__item o-grid--vert--center u-vw--100">
										<label id="MyFirstNameLabel" for="MyFirstName" data-required class="c-brand--form__label o-grid--none @mv-o-grid--none o-grid__col @xs-u-vw--30 fn--right">First Name</label>
										<input id="FirstName" maxlength="50" name="FirstName" type="text" data-validation-message="First Name" data-regex="<%=nameValidationRegex %>" data-regex-message="First name can only contain letters." placeholder="First Name" aria-labelledby="MyFirstNameLabel" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
									</li>
		
									<!-- // Last Name -->
									<li id="MyLastNameCt" class="c-brand--form__item o-grid--vert--center u-vw--100">
										<label id="MyLastNameLabel" for="MyLastName" data-required class="c-brand--form__label o-grid--none @mv-o-grid--none o-grid__col @xs-u-vw--30 fn--right">Last Name</label>
										<input id="LastName" maxlength="50" name="LastName" type="text" data-validation-message="Last Name" data-regex="<%=nameValidationRegex %>" data-regex-message="Last name can only contain letters." placeholder="Last Name" aria-labelledby="MyLastNameLabel" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
									</li>
		
									<!-- // Email -->
									<li id="FriendEmailCt" class="c-brand--form__item o-grid--vert--center u-vw--100">
										<label id="FriendEmailLabel" for="FriendEmail" data-required class="c-brand--form__label o-grid--none @mv-o-grid--none o-grid__col @xs-u-vw--30 fn--right">Email</label>
										<input id="Email" maxlength="50" name="Email" type="email" data-regex="^(([^<>()\[\]\\.,;:\s@&quot;]+(\.[^<>()\[\]\\.,;:\s@&quot;]+)*)|(&quot;.+&quot;))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$" data-regex-message="Please enter a valid email" data-validation-message="Email" placeholder="email@example.com" aria-labelledby="FriendEmailLabel" aria-required="true" class="c-brand--form__input o-grid__col o-box o-shadow @xs-u-vw--100 fx--animate">
									</li>
		
								</ul>
		
							</li>
		
						</ul>
		
						<hr class="c-brand--form__hr">
		
						<button type="button" name="acceptOffer" data-invite-title="feedback" id="AdditonalLeads" onclick="handleInviteSubmit(this, {
							validate : 'data-validation-message',
                            regex : 'data-regex',
                            regexMessage : 'data-regex-message',
							result : 'data-result',
							fieldset : 'data-fieldset',
							headline : 'data-invite-headline',
							message : 'data-invite-message',
							content : 'data-invite-content',
							title : 'data-invite-title'
						});" class="fn--ucase u-mar--center u-vw--100 animate o-box--btn--icon o-pos">
							<i class="o-grid--iblock icon-envelop"></i>
							<p class="o-grid--iblock no-margin left-padding">Share the Opportunity!</p>
						</button>
		
					</fieldset>
		
				</form>
			</div>

		</div>

	</div>

	<script type="text/javascript">
		// get html
		var $html = $('html');
		// get invite container
		var $invite = $('#invite-friend');
		// get invite link
		var $invite__link = $('a[href="#invite-friend"]');
		// get vse 
		var $vse = $('.invite__vse');

		// set config options
		var cf = {
			startEffect : '<%= inviteValidationStartEffect %>',
			endEffect : 'fadeSlideUp',
			duration : <%= inviteValidationDuration %>,
			easing : '<%= inviteValidationEasing %>',
		};

		// get refer URL from the CM control
		var controlReferURL = '<%= ViewData["ReferURL"] %>';
		// get original invite message
		var $og_message = $('[data-invite-message]').html();

		// get selector for result attribute
		var result = master.search('selectAttr', { attr : 'data-result' }).func;
		// cache result selector as jQuery object
		var $result = $(result);

		// get selector for fieldset
		var fieldset = master.search('selectAttr', { attr : 'data-fieldset' }).func;
		// cache fieldset selector as jQuery object
		var $fieldset = $(fieldset);

		// get selector for headline
		var headline = master.search('selectAttr', { attr : 'data-invite-headline' }).func;
		// cache headline selector as jQuery object
		var $headline = $(headline);

		// get selector for message
		var message = master.search('selectAttr', { attr : 'data-invite-message' }).func;
		// cache message selector as jQuery object
		var $message = $(message);

		// get selector for content
		var content = master.search('selectAttr', { attr : 'data-invite-content' }).func;
		// cache content selector as jQuery object
		var $content = $(content);

		// set reset form function
		var resetInviteForm = function () {
			// change status to false
			inviteStatus = false;

			// get current button
			var $self = $self || $('#AdditonalLeads');
			// get attached form
			var form = form || $self.closest('form');
			// get input
			var input = form.find('.c-brand--form__input');

			// clear all values
			master.search('cycle', {
				obj : input,
				callback : function(index, value, args) {
					$(value).val('');
				}
			});

			// update headline text
			$headline.text('<%= inviteHeadline %>');

			// update description message
			$message.html($og_message);

			// fade out the success message
			$result.fadeOut(function () {
				// run start effect to open the form fields
				$fieldset[cf.startEffect](cf.duration, cf.easing);
				// show the submit button
				$self.fadeIn();

				// clear out the content
				//$content.removeAttr('style').removeAttr('class');
				// clear out the results
				$result.removeAttr('style').removeAttr('class').html('');

				// set focus to first input
				input.eq(0).focus();
			});

			// disable submit button
			$self.removeClass('disable-click');
		};

		// set invite status
		var inviteStatus = false;

		// set event for invite form to reset when fancybox closes
		$invite.on('dtm/fancybox/close', function () {
			if ( inviteStatus ) {
				resetInviteForm();
			}
		});

		// when invite a guest launches, set focus to it
		$invite__link.on('dtm/fancybox/open', function () {
			$invite.find('.invite__header').focus();
		});

		(function($, document, window, undefined) {

			$(window).load(function() {

				/* @Swap
				* --------------------------------------------------------------------- */
				$('.c-brand--invite').eflex({
					type : 'swap',
					title : 'data-invite-title',
					content : 'data-invite-content',
					startEffect : cf.startEffect,
					endEffect : cf.endEffect,
					duration : cf.duration,
					easing : cf.easing,
					freeze : true
				});

				<% if ( showFormOnPageLoad ) { %>
					// display pop up invite on page load
					$invite__link.trigger('click');
				<% } %>

			});

			<% if ( showFormOnPageLoad ) { %>
				// action : pause all vimeo videos
				$html.on('dtm/vimeo', function (vimeo) {
					$.each(vimeo.api, function () {
						this.pause();
					});
				});

				// action : pause all youtube videos
				$html.on('dtm/youtube', function (youtube) {
					$.each(youtube.api, function () {
						this.pauseVideo();
					});
				});
			<% } %>

		})(jQuery, document, window);

		function renderFeedback($elem, status, data, sr) {
			switch (status) {
				case 'success':
					$elem
						.addClass('o-box--msg-success no-margin')
						.html('<em><i class="icon-checkmark u-pad--right"></i>' + data + '</em>');
					break;
				case 'error':
					var title = 'Oops! Please fix and try again.';
					sr =  title + ' ' + sr;
					$elem
						.addClass('o-box--msg-error validation-summary-errors')
						.html('<span><i class="icon-cross u-pad--right"></i>' + title + '</span><ul>' + data + '</ul>');
					break;
			}

			if ( $vse.find('.screen-reader-only').length === 0 ) {
				$('<span/>', {
					tabindex : 0,
					class : 'screen-reader-only',
					html : sr
				}).prependTo($vse);
			} else {
				$vse.find('.screen-reader-only').html(sr);
			}

			$vse.find('.screen-reader-only').focus();
		}

		function handleInviteSubmit(self, args) {
			// get current button
			var $self = $(self);
			// get attached form
			var form = $self.closest('form');
			// collect form values
			var vals = {};

			// set error container
			var error = {
				hits : 0, message : '', html : '', sr : ''
			};

			// set valid container
			var valid = {};

			// iterate through all fields and check if they're blank
			master.search('cycle', {
				obj : form.find('input'),
				callback : function(index, value) {
					// if field is blank
					if ( $(value).val() === '' ) {
						error.hits += 1;
						error.message = $(value).attr(args.validate) + ' is required';
						error.sr += error.message + ' ';
						error.html += '<li>' + error.message + '</li>';
                    } else if (typeof($("#" + value.id).attr(args.regex)) != 'undefined' && !RegExp($("#" + value.id).attr(args.regex)).test($("#" + value.id).val()))
                    {
                        error.hits += 1;
                        error.message = $(value).attr(args.regexMessage);
                        error.sr += error.message + ' ';
                        error.html += '<li>' + error.message + '</li>';
                    }
                    else {
						valid[index] = $(value).val();
					}
				}
			});

			if ( error.hits > 0 ) {

				// apply error message
				renderFeedback($result, 'error', error.html, error.sr);

			} else {

				// disable submit button
				$self.addClass('disable-click');

				$.ajax({
					type : 'POST',
                    url: '/Services/Invite.ashx',
					data : $("#inviteForm").serialize(),
					success : function (data) {

                        if (data.error != null && data.error.length > 0) {
							// change status to false
							inviteStatus = false;
							// empty out messages
							error.messages = '';
							error.sr = '';
							// iterate each error and add new message
							for (var i = 0; i < data.error.length; i++) {
								error.messages += '<li>' + data.error[i] + '</li>';
								error.sr += data.error[i] + ' ';
								console.log(data.error[i]);
							}

							// display error feedback
							renderFeedback($result, 'error', error.messages, error.sr);
							// disable submit button
							$self.removeClass('disable-click');
						} else {
							// change status to true
							inviteStatus = true;
							// display success feedback
							$result.fadeOut(function() {
								renderFeedback($result, 'success', '<%= inviteSuccessMessage %>', '<%= inviteSuccessMessage %>');
								$result.addClass('block');
								$result.fadeIn();
							});

							// update headline text
							$headline.text('<%= inviteSuccessHeadline %>');
							//hide description message
							$message.html('<a data-reload-invite href="javascript:;">Click here to invite another guest</a>');
							//hide submit button
							$self.hide();

							// run end effect to close the form fields
							$fieldset[cf.endEffect](cf.duration, cf.easing);

							// set up event to let the form reload
							$('[data-reload-invite]').one('click', resetInviteForm);
						}

					},
                    error: function (data) {
						// change status to false
						inviteStatus = false;
						error.messages = 'Please verify all fields are populated and try again!';
						// error happened while posting
						renderFeedback($result, 'error', error.messages, error.messages);
						// disable submit button
						$self.removeClass('disable-click');
					}
				});
			}
		}


	</script>
