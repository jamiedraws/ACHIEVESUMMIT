<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.ClientSites.Web.ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce" %>
<%@ Import Namespace="Dtm.Framework.Base.Enums" %>

<% 
    var allowedPages = Dtm.Framework.ClientSites.SettingsManager.ContextSettings["Order.EditableAddressEnabledPageCodes", ""];
    var removeColumns = ((String)ViewData["removeColumns"] ?? String.Empty).ToLower();
    var validatePoBilling = SettingsManager.ContextSettings["Validation.ValidatePOBoxRegexPattern", false];
    var validatePoShipping = SettingsManager.ContextSettings["DTM.ClientSites.ValidateShippingPOBox", false];
    var poBoxValidationText = LabelsManager.Context["PoBoxAddressNotAllowedError", "Cannot ship to a P.O. Box. You may enter separate billing and shipping addresses."];
    bool? showContactInfo = ViewData["showContactInfo"] as bool?;
    bool? editInfoIndividually = ViewData["editInfoIndividually"] as bool?;
    var billingHeader = ViewData["billingHeader"] as string;
    var shippingHeader = ViewData["shippingHeader"] as string;
    var isEditable = ViewData["isEditable"] as bool?;

%>

<% if (allowedPages.Contains(DtmContext.PageCode) && (!isEditable.HasValue || isEditable.Value)) { %>

	<!-- // Editable Address -->
	<div data-edit-form class="c-brand--edit">

		<% Html.BeginForm(); %>
            <input type="hidden" id="ShippingIsSameAsBilling" value="<%=removeColumns.Contains( "shipping" ) %>" />
			<ul class="edit__list c-list--horz o-grid u-vw--100">

				<!-- // Editor Note :: @Mobile -->
				<li class="c-list__item edit__note note--mobile will-show @mv-u-vw o-grid--none @mv-u-pad--vert">
					<div class="o-box--none note--box u-vw--100 fn--center">
						<p class="u-mar--reset">Information that is highlighted in this text color can be edited by clicking on it.</p>
					</div>
				</li>

				<% if ( !removeColumns.Contains( "billing" ) ) {
                        %>
				<!-- // Billing Address -->
				<li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
					<% if ( Model.Order.PaymentType == PaymentType.Card ) { %>
						<h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold"><%= billingHeader ?? LabelsManager.Labels["ConfirmationBillingHeadline"]  %></h3>
						<ul data-edit-address data-edit-addressBilling class="c-list--reset">
							<li class="o-grid">
								<input id="BillingFirstName" name="BillingFirstName" type="text" value="<%= Model.Order.BillingFirstName %>" class="dtm__restyle">&nbsp;
								<input id="BillingLastName" name="BillingLastName" type="text" value="<%= Model.Order.BillingLastName %>" class="dtm__restyle">
							</li>
							<li>
								<input id="BillingStreet" name="BillingStreet" type="text" value="<%= Model.Order.BillingStreet %>" class="dtm__restyle">
							</li>
							<li>
								<input id="BillingStreet2" name="BillingStreet2" type="text" value="<%= Model.Order.ShippingStreet2 %><%= string.IsNullOrEmpty(Model.Order.BillingStreet2) ? string.Empty : "" %>" class="dtm__restyle">
							</li>
							<li>
								<input id="BillingCity" name="BillingCity" type="text" value="<%= Model.Order.BillingCity %>" class="dtm__restyle">,
								<span id="BillingState">
									<%=Html.DropDownListFor(m => m.Order.BillingState, new SelectList(DtmContext.CampaignStates, "StateCode", "StateName", Model.Order.BillingState)) %>
								</span>
								<input id="BillingZip" name="BillingZip" type="text" value="<%= Model.Order.BillingZip %>" class="dtm__restyle">
								<input type="hidden" id="BillingCountry" name="BillingCountry" value="<%= Model.Order.BillingCountry %>" class="dtm__restyle">
							</li>
                            <%if (!showContactInfo.HasValue || !showContactInfo.Value)
                                { %>
							<li class="no-border"><%= Model.Order.Email %></li>
                            <%} %>
                            <%if (editInfoIndividually.HasValue && editInfoIndividually.Value)
                                    { %>
                                <li>
                                    <a data-edit-address-link data-edit-addressBilling-link>Edit</a>
                                </li>
                                <%} %>
						</ul>
					<% } %>
				</li>
				<% } %>


				<% if ( !removeColumns.Contains( "shipping" ) ) { %>
				<!-- // Shipping Address -->
				<li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
					<h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold"><%= shippingHeader ?? LabelsManager.Labels["ConfirmationShippingHeadline"] %></h3>
					<ul data-edit-address data-edit-addressShipping class="c-list--reset">
						<li class="o-grid">
							<input id="ShippingFirstName" name="ShippingFirstName" type="text" value="<%= Model.Order.ShippingFirstName %>" class="dtm__restyle">&nbsp;
							<input id="ShippingLastName" type="text" name="ShippingLastName" value="<%= Model.Order.ShippingLastName %>" class="dtm__restyle">
						</li>
						<li>
							<input id="ShippingStreet" name="ShippingStreet" type="text" value="<%= Model.Order.ShippingStreet %>" class="dtm__restyle">
						</li>
						<li>
							<input id="ShippingStreet2" name="ShippingStreet2" type="text" value="<%= Model.Order.ShippingStreet2 %><%= string.IsNullOrEmpty(Model.Order.ShippingStreet2) ? string.Empty : "" %>" class="dtm__restyle">
						</li>
						<li>
							<input id="ShippingCity" type="text" name="ShippingCity" value="<%= Model.Order.ShippingCity %>" class="dtm__restyle">,
							<span id="ShippingState">
								<%= Html.DropDownListFor(m => m.Order.ShippingState, new SelectList(DtmContext.CampaignStates, "StateCode", "StateName", Model.Order.ShippingState)) %>
							</span>
							<input id="ShippingZip" type="text" name="ShippingZip" value="<%= Model.Order.ShippingZip %>" class="dtm__restyle">
							<input type="hidden" id="ShippingCountry" name="ShippingCountry" value="<%= Model.Order.ShippingCountry %>" class="dtm__restyle">
						</li>
                        <%if (editInfoIndividually.HasValue && editInfoIndividually.Value)
                                    { %>
                                <li>
                                    <a data-edit-address-link data-edit-addressShipping-link>Edit</a>
                                </li>
                                <%} %>
					</ul>
				</li>
				<% } %>
                
                
                <%
                    if (showContactInfo.HasValue && showContactInfo.Value)
                    {
                %>
                        <li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
					        <h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold">Contact Info:</h3>
					        <ul data-edit-address data-edit-addressContact class="c-list--reset">
						        <li class="o-grid">
                                    Phone:&nbsp;
							        <input id="Phone" name="Phone" type="text" value="<%= Model.Order.Phone %>" class="dtm__restyle">
						        </li>
						        <li>
                                    Email:&nbsp;
							        <input id="Email" name="Email" type="text" value="<%= Model.Order.Email %>" class="dtm__restyle">
						        </li>
                                <%if (editInfoIndividually.HasValue && editInfoIndividually.Value )
                                    { %>
                                <li>
                                    <a data-edit-address-link data-edit-addressContact-link>Edit</a>
                                </li>
                                <%} %>
					        </ul>
				        </li>
                <%
                    }
                %>


				<% if ( !removeColumns.Contains( "payment" ) ) { %>
				<!-- // Payment Method -->
				<li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
					<h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold"><%= LabelsManager.Labels["ConfirmationPaymentHeadline"] %></h3>
					<ul class="c-list--reset">
					<% if (Model.Order.PaymentType == PaymentType.Checkout) { %>
						<% if (Model.Order.CardType.Contains("AMAZON")) { %>
						<li>Amazon</li>

						<% } else if (Model.Order.CardType.Contains("PAYPAL")) { %>
						<li>PayPal</li>

						<% } else { %>
						<li><%= Model.Order.CardType %></li>

						<% } %>
						<li><%=Model.Order.Email %></li>
					<% } else { %>
						<li><%= LabelsManager.Labels["ConfirmationPaymentCardType"] %> <%= Model.Order.CardType %></li>
                        <%if (!string.IsNullOrWhiteSpace(Model.Order.Codes["Username"].Code)){ %><li><%=LabelsManager.Labels["ConfirmationPaymentUsername", "Account:"] %> <%= Model.Order.Codes["Username"].Code %></li><%} %>
						<%if (!string.IsNullOrWhiteSpace(Model.Order.CardNumber)) { %><li><%= LabelsManager.Labels["ConfirmationPaymentLastDigits"] %> <%= string.IsNullOrEmpty(Model.Order.CardNumber) ? "" : Model.Order.CardNumber.Substring(Model.Order.CardNumber.Length - 4, 4) %></li><%} %>
						<%if (!string.IsNullOrWhiteSpace(Model.Order.CardExpiration)) { %><li><%= LabelsManager.Labels["ConfirmationPaymentExpirationDate"] %> <%= Model.Order.CardExpiration %></li><%} %>
					<% } %>
					</ul>
				</li>
				<% } %>

			</ul>

			<div class="@mv-fn--center o-grid--vert--center u-mar--top">
				<div class="@mv-u-vw o-grid__col">
                    <%if ((!editInfoIndividually.HasValue || !editInfoIndividually.Value) )
                        { %>
					<a href="javascript:;" class="o-box--none address--box no-text-decoration" data-edit-address-link>Edit Address <i class="icon-edit"></i></a>
					<%} %>
                    <button type="submit" class="o-grid--none address--box o-box--none no-text-decoration u-vw--100" data-save-address-link>Save Address <i class="icon-checkmark"></i></button>
				</div>
				<!-- // Editor Note :: @Desktop -->
				<div class="@mv-u-vw o-grid__col edit__note note--desktop will-show fx--clip-inset @mv-o-grid--none">
					<div class="o-box--none note--box">
						<p class="u-mar--reset"><i class="icon-chevron-thin-right"></i> Information that is highlighted in this text color can be edited by clicking on it.</p>
					</div>
				</div>
			</div>

		<% Html.EndForm(); %>

	</div>

	<!-- // Error Message Container -->
	<div id="errorContainer" class="clearfix vse o-grid--none u-pad--top @x2-pad">
		<div id="errorLabelContainer" class="o-box--msg-error error-message-container u-vw--100"></div>
	</div>

	<!-- // Success Message Container -->
	<div id="successContainer" class="clearfix o-grid--none u-pad--top @x2-pad">
		<div id="successLabelContainer" class="o-box--msg-success sucess-message-container center-text u-vw--100">
			<i class="icon-checkmark"></i> Thank you <em data-billing-first-name><%= Model.Order.BillingFirstName %></em>! Your information has been updated.
		</div>
	</div>

	<script>
		(function($, document, window, undefined) {
			// Get form
			var $form = $('[data-edit-form] form');
			// Get inputs
			var $input = $('[data-edit-address] input');
			// Get selects
			var $select = $('[data-edit-address] select');

			// Get edit address attribute
			var $editAddress = $('[data-edit-address]');
			// Get edit link
            var $editAddressLink = $('[data-edit-address-link]');
            var $editAddressBillingLink = $('[data-edit-addressBilling-link]');
            var $editAddressShippingLink = $('[data-edit-addressShipping-link]');
            var $editAddressContactLink = $('[data-edit-addressContact-link]');
			// Get save link
			var $saveAddressLink = $('[data-save-address-link]');
			// Get success container
			var $successContainer = $('#successContainer');
			// Get note container
			var $noteContainer__dv = $('[data-edit-form] .note--desktop');
			var $noteContainer__mv = $('[data-edit-form] .note--mobile');

	        /* @Get Text Width
			* --------------------------------------------------------------------- */
	        function getTextWidth (text, font) {
	            // re-use canvas object for better performance
	            var canvas = getTextWidth.canvas || (getTextWidth.canvas = document.createElement("canvas"));
	            var context = canvas.getContext("2d");
	            context.font = font;
	            var metrics = context.measureText(text);
	            return metrics.width;
	        }

	        /* @Set Text Width :: Shortcut to Get Text Width function
			* --------------------------------------------------------------------- */
	        function setTextWidth ($this, text) {
	            return getTextWidth(text, $this.css('font-weight') + ' ' + $this.css('font-size') + ' ' + $this.css('font-family'));
	        }

	        /* @Set Address Lines
			* --------------------------------------------------------------------- */
	        function setAddressLines () {
	            var $fieldset = $('[data-edit-address]');
	            // Get inputs
	            var $input = $fieldset.find('input');
	            // Get selects
	            var $select = $fieldset.find('select');

	            // Add support for dynamic text width and disable inputs
	            $('.c-brand--edit input:not([type="email"]), .c-brand--edit select')
	                .addClass('has-dynamic-width').prop('disabled', true);

	            // Set max-width range on all fields
	            $fieldset.each(function (index, value) {
	                var w = $(value).width() - 4;
	                $(value).find('input, select').css({ 'max-width' : w });
	            });

	            // on every input, update the text width
	            $input.on('input', function() {
	                // fetch new text width
	                var length = setTextWidth($(this), $(this).val());

	                // update width
	                $(this).css({ width : Math.ceil(length) + 1 });
	            }).trigger('input')
	                .closest('.c-brand--edit')
	                .addClass('show-address');

	            // on every input, update the text width
	            $select.on('change', function() {
	                // fetch new text width
	                var length = setTextWidth($(this), $(this).find('option:selected').text());

	                // update width
	                $(this).css({ width : Math.ceil(length) + 5 });
	            }).trigger('change');
	        }


			/* @Save Address
			* --------------------------------------------------------------------- */
			// Add click listener for the save address link
			function saveAddress () {
				// Set data object
				var data = {};
				// Set count array
				var count = {};

				// Get address data from all input fields
				$input.each(function () {
					data['Order.' + $(this).attr('id')] = $(this).val();
				});

				// Get address data from all select fields
				$select.each(function () {
					data['Order.' + $(this).closest('span').attr('id')] = $(this).val();
				});

				
                data['Order.ShippingIsSameAsBilling'] = $("#ShippingIsSameAsBilling").val();

				//console.log(data);

				$.ajax({
					type: 'POST',
					url: '/shared/services/Order.ashx?m=UAI&v=<%= DtmContext.Version %>&o=<%= DtmContext.OfferCode %>',
					data: $.param(data),
					//data: $(data).serialize(),
					success: function (rdata, textStatus, jqXHR) {
						// Remove styling state to reflect editable fields to the user
						$editAddress.removeClass('address-is-editable');

						// Make lines uneditable
						$input.prop('disabled', true);
						$select.prop('disabled', true);

						// Hide save link
						$saveAddressLink.hide();
						// Show edit link
						$editAddressLink.show();
						// Hide note
						if ( Model.IsMobile ) {
							$noteContainer__mv.fadeSlideUp();
						} else {
							$noteContainer__dv.removeClass('show-clip');
						}

						// Display success message with updated first name
						$successContainer.find('[data-billing-first-name]').text(data['Order.BillingFirstName']);
						$successContainer.fadeSlideDown();
					}
				});
			}

			$('html').on('dtm/validate', function () {
				var data = {};

				$form.find('input').each(function (index, value) {
					data[$(value).attr('id')] = {
						value : $(value).val(),
						length : $(value).width()
					}
				});

				console.log(data);

				// Set jQuery Validate
            

                $.validator.addMethod(
                    "POBox",
                    function (value, element) {

                        const regex = /\bp([.]|ost)? ?O([.]|ffice)? ?box\b/igm;
                        const str = value;
                        var hasMatch = false;
                        let m;

                        while ((m = regex.exec(str)) !== null) {
                            // This is necessary to avoid infinite loops with zero-width matches
                            if (m.index === regex.lastIndex) {
                                regex.lastIndex++;
                            }

                            // The result can be accessed through the `m`-variable.
                            for (var i = 0; i < m.length; i++) {
                                hasMatch = true;
                            }
                        
                        }
                        return !hasMatch;
                    },
                    '<%=poBoxValidationText%>'
                );

                $.validator.addMethod(
                    "email",
                    function (value) {
                        var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                        return reg.test(value);
                    },
                     'Please enter a valid email address'
                );

                $.validator.addMethod(
                    "phone",
                    function (value) {
                        var phone = value.replace(/[^0-9]/g, "");
                        if (phone.length != 10) {
                            return false;
                        }
                        return true;
                    },
                    'Please enter a valid phone number'
                );

				$form.validate({
					rules : {
						BillingFirstName : 'required',
						BillingLastName : 'required',
                        BillingStreet: {
                            required: true<%if(validatePoBilling) {%>,                           
                             POBox: true
                         <% }%>},
						BillingCity : 'required',
						BillingCountry : 'required',
						BillingZip : {
							required : true,
							number : true
                        },
                        <%if (showContactInfo.HasValue && showContactInfo.Value) {%>
                        Email: { required: true, email: true},
                        Phone: { required: true, phone: true},
                        <%}%>
						ShippingFirstName : 'required',
						ShippingLastName : 'required',
                        ShippingStreet: {
                            required: true<%if(validatePoShipping) {%>,
                            POBox: true
                         <% }%>},
						ShippingCity : 'required',
						ShippingCountry : 'required',
						ShippingZip : {
							required : true,
							number : true
						}
					},
					messages : {
						BillingFirstName : 'Billing first name is required.',
                        BillingLastName: 'Billing last name is required.',
                        BillingStreet: {
                            required: 'Billing street address is required.',
                            POBox: "<%=poBoxValidationText%>"
                         },
						BillingCity : 'Billing city is required.',
						BillingCountry : 'Billing country is required.',
                        BillingZip: 'Billing zip code is required.',
                        <%if (showContactInfo.HasValue && showContactInfo.Value) {%>
                        Email: {
                            required: 'Email address is required',
                            email: 'Please enter a valid email address'
                            },
                        Phone: {
                            required: 'Phone is required',
                            phone: 'Please enter a valid phone number'
                            },
                        <%}%>
						ShippingFirstName : 'Shipping first name is required.',
						ShippingLastName : 'Shipping last name is required.',
                        ShippingStreet: {
                            required: 'Shipping street address is required.',
                            POBox: "<%=poBoxValidationText%>"
                        },
						ShippingCity : 'Shipping city is required.',
						ShippingCountry : 'Shipping country is required.',
						ShippingZip : 'Shipping zip code is required.'
					},
					errorContainer : '#errorContainer',
					errorLabelContainer : '#errorLabelContainer',
					wrapper : 'li',
					onfocusout : function (element) {
						$(element).valid();
						if ( $(element).hasClass('error') ) {
							$(element).attr({ 'value' : data[$(element).attr('id')].value }).css({ 'width' : data[$(element).attr('id')].length });
							$(element).closest('li').addClass('has-errors');
							$('.vse').eflex({ type : 'scroll', trigger : true });
						}
					},
					submitHandler: function (form) {
						$saveAddressLink.prop('disabled', true);
						saveAddress();
					}

                });

            <% 
                if (editInfoIndividually.HasValue && editInfoIndividually.Value)
                {
            %>
                    $editAddressBillingLink.on("click", function () {
                        EditAddress($("[data-edit-addressBilling]"), $("[data-edit-addressBilling] input"), $("[data-edit-addressBilling] select"));
                    });
                    $editAddressShippingLink.on("click", function () {
                        EditAddress($("[data-edit-addressShipping]"), $("[data-edit-addressShipping] input"), $("[data-edit-addressShipping] select"));
                    });
                    $editAddressContactLink.on("click", function () {
                        EditAddress($("[data-edit-addressContact]"), $("[data-edit-addressContact] input"), $("[data-edit-addressContact] select"));
                    });
            <%
                }else
                {
            %>
                    // Add click listener for the edit address link
                    $editAddressLink.fadeIn().on('click', function () { EditAddress() });
            <%
                }
            %>
			    

                function EditAddress(editAddress, input, select) {

                    if (!editAddress) {
                        editAddress = $editAddress;
                    }

                    if (!input) {
                        input = $input;
                    }

                    if (!select) {
                        select = $select;
                    }

					// Add styling state to reflect editable fields to the user
                    editAddress.addClass('address-is-editable');

			        // Make lines editable
                    input.prop('disabled', false);
                    select.prop('disabled', false);

			        // Hide edit link
			        $(this).hide();
					// Show save link and make clickable
					$saveAddressLink.show().prop('disabled', false);

					// Show note
					if ( Model.IsMobile ) {
						$form.eflex({
							type : 'scroll',
							trigger : true,
							onAfter : function () {
								$noteContainer__mv.fadeSlideDown();
							}
						});
					} else {
						$noteContainer__dv.addClass('show-clip');
					}

					// Hide success message
					$successContainer.fadeSlideUp();
			    };

			});

            $(document).ready(function () {
                //Block processing popup
                $form.attr("data-submitting-state", "addressForm");

	            // make address lines editable
	            setAddressLines();
				// Check if jQuery Validate is not already installed
				if ( $('script[src*="jquery.validate"]').length === 0 ) {
					// fetch the script from the shared
					$.getScript('/shared/js/jquery.validate.min.js')
						.done(function () {
							// trigger validation event
							$('html').trigger('dtm/validate');
						})
						.fail(function ( jqxhr, settings, exception ) {
							console.log(jqxhr);
							console.log(settings);
							console.log(exception);
						});
				} else {
					// trigger validation event
					$('html').trigger('dtm/validate');
				}

            });



		})(jQuery, document, window);
	</script>

<% } else { %>

	<ul class="c-list--horz o-grid u-vw--100 c-brand--viewdata">

		<% if ( !removeColumns.Contains( "billing" ) ) { %>
		<!-- // Billing Address -->
		<li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
			<% if ( Model.Order.PaymentType == PaymentType.Card ) { %>
				<h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold"><%= LabelsManager.Labels["ConfirmationBillingHeadline"] %></h3>
				<ul class="c-list--reset viewdata--truncate--list">
					<li data-tip="<%= Model.Order.BillingFirstName %> <%= Model.Order.BillingLastName %>">
						<span class="truncate__viewdata"><%= Model.Order.BillingFirstName %> <%= Model.Order.BillingLastName %></span>
					</li>
					<li data-tip="<%= Model.Order.BillingStreet %>">
						<span class="truncate__viewdata"><%= Model.Order.BillingStreet %></span>
					</li>
					<li data-tip="<%= Model.Order.BillingStreet2 %><%= string.IsNullOrEmpty(Model.Order.BillingStreet2) ? string.Empty : "" %>">
						<span class="truncate__viewdata"><%= Model.Order.BillingStreet2 %><%= string.IsNullOrEmpty(Model.Order.BillingStreet2) ? string.Empty : "" %></span>
					</li>
					<li data-tip="<%= Model.Order.BillingCity %>, <%= Model.Order.BillingState %> <%= Model.Order.BillingZip %>">
						<span class="truncate__viewdata"><%= Model.Order.BillingCity %>, <%= Model.Order.BillingState %> <%= Model.Order.BillingZip %></span>
					</li>
                    <%if (!showContactInfo.HasValue || !showContactInfo.Value)
                        { %>
					<li data-tip="<%= Model.Order.Email %>">
						<span class="truncate__viewdata"><%= Model.Order.Email %></span>
					</li>
                    <%} %>
				</ul>
			<% } %>
		</li>
		<% } %>


		<% if ( !removeColumns.Contains( "shipping" ) ) { %>
		<!-- // Shipping Address -->
		<li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
			<h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold"><%= LabelsManager.Labels["ConfirmationShippingHeadline"] %></h3>
			<ul class="c-list--reset viewdata--truncate--list">
				<li data-tip="<%= Model.Order.ShippingFirstName %> <%= Model.Order.ShippingLastName %>">
					<span class="truncate__viewdata"><%= Model.Order.ShippingFirstName %> <%= Model.Order.ShippingLastName %></span>
				</li>
				<li data-tip="<%= Model.Order.ShippingStreet %>">
					<span class="truncate__viewdata"><%= Model.Order.ShippingStreet %></span>
				</li>
				<li data-tip="<%= Model.Order.ShippingStreet2 %><%= string.IsNullOrEmpty(Model.Order.ShippingStreet2) ? string.Empty : "" %>">
					<span class="truncate__viewdata"><%= Model.Order.ShippingStreet2 %><%= string.IsNullOrEmpty(Model.Order.ShippingStreet2) ? string.Empty : "" %></span>
				</li>
				<li data-tip="<%= Model.Order.ShippingCity %>, <%= Model.Order.ShippingState %> <%= Model.Order.ShippingZip %>">
					<span class="truncate__viewdata"><%= Model.Order.ShippingCity %>, <%= Model.Order.ShippingState %> <%= Model.Order.ShippingZip %></span>
				</li>
			</ul>
		</li>
		<% } %>

        <%
            if (showContactInfo.HasValue && showContactInfo.Value)
            {
        %>
                <li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
					<h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold">Contact Info:</h3>
					<ul class="c-list--reset viewdata--truncate--list">
						<li data-tip="<%= Model.Order.Phone %>" class="o-grid">
                            Phone:&nbsp;
							<span class="truncate__viewdata"><%= Model.Order.Phone %></span>
						</li>
						<li data-tip="<%= Model.Order.Email %>">
                            Email:&nbsp;
							<span class="truncate__viewdata"><%= Model.Order.Email %></span>
						</li>
					</ul>
				</li>
        <%
            }
        %>

		<% if ( !removeColumns.Contains( "payment" ) ) { %>
		<!-- // Payment Method -->
		<li class="c-list__item o-grid__col @mv-u-vw--33 @mv-u-pad--vert">
			<h3 class="c-brand--box c-brand__headline--box c-brand--sm o-box--block bold"><%= LabelsManager.Labels["ConfirmationPaymentHeadline"] %></h3>
			<ul class="c-list--reset viewdata--truncate--list">
			<% if (Model.Order.PaymentType == PaymentType.Checkout) { %>
				<% if (Model.Order.CardType.Contains("AMAZON")) { %>
				<li>Amazon</li>

				<% } else if (Model.Order.CardType.Contains("PAYPAL")) { %>
				<li>PayPal</li>

				<% } else { %>
				<li><%= Model.Order.CardType %></li>

				<% } %>
				<li><%=Model.Order.Email %></li>
			<% } else { %>
				<li><%= LabelsManager.Labels["ConfirmationPaymentCardType"] %> <%= Model.Order.CardType %></li>
				<li><%= LabelsManager.Labels["ConfirmationPaymentLastDigits"] %> <%= string.IsNullOrEmpty(Model.Order.CardNumber) ? "" : Model.Order.CardNumber.Substring(Model.Order.CardNumber.Length - 4, 4) %></li>
				<li><%= LabelsManager.Labels["ConfirmationPaymentExpirationDate"] %> <%= Model.Order.CardExpiration %></li>
			<% } %>
			</ul>
		</li>
		<% } %>

	</ul>

<% } %>
