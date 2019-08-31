APP.controllers.tool_rentals = (function() {

    function init() {
      if ($(".tool-rental-page").exists()) {
        APP.components.tabs.initTabs(".tabs-ctrl");
        initLoginScreen();
        initAddressScreen();
        initPaymentScreen();
        initSummaryScreen();
      }
    }

    function initLoginScreen() {
      // Change Wording of Notice Message for Toolteiler Registrations
      if ($("#flash .notice").exists()) {
        var flashText = $("#flash .notice").text();
        if (flashText.indexOf('Vielen Dank für Deine Registrierung.') >= 0){
          // Modifiy Message for Toolteiler Registrations
          $("#flash .notice").text('Vielen Dank für Deine Registrierung. Du bist jetzt angemeldet und kannst mit deiner Toolteiler Anfrage fortfahren..');
        }
      }
    }

    function initAddressScreen() {
      var screen = $("#tab-address");
      screen.find(".next-screen").on("click", function() {
        $('#tab-summary .renter-summary .renter-company').text(screen.find(".renter-company-input").val());
        $('#tab-summary .renter-summary .renter-name').text(screen.find(".renter-name-input").val());
        $('#tab-summary .renter-summary .renter-address').text(screen.find(".renter-address-input").val());
        $('#tab-summary .renter-summary .renter-zip').text(screen.find(".renter-zip-input").val());
        $('#tab-summary .renter-summary .renter-city').text(screen.find(".renter-city-input").val());
        openTab('payment');
      });
    }

    function initPaymentScreen() {
      var screen = $("#tab-payment");
      screen.find(".paymentMethods input").on("click", function() {
        screen.find(".payment-method-container").hide();
        screen.find("." + $(this).val() + "-container").show();
      });

      initCardPayment();
    }

    function initCardPayment() {

      var container = $(".card-container");

      var elements = stripe.elements({
        fonts: [
          { cssSrc: 'https://fonts.googleapis.com/css?family=Lato:400,400i,300' }
        ]
      });

      var style = {
        base: {
          fontFamily: '"Lato", sans-serif',
          fontWeight:400,
          fontSmoothing: 'antialiased',
          fontSize: '16px',
          color:'#615454',
          '::placeholder': {
            color: '#83C7BD',
            fontStyle:'italic'
          },
          iconColor:'#69a8a7'
        }
      };

      var cardElement = elements.create('card', {style: style, hidePostalCode: true, classes: {base: 'input-plain'}});
      cardElement.mount('#card-element');

      var paymentMethod;

      container.find(".next-screen").on("click", function() {
        container.find(".next-screen").prop("disabled", true);
        container.find(".error-message").text("");
        stripe.createPaymentMethod('card', cardElement, {
          billing_details: { name: container.find("#cardholder-name").val() }
        }).then(function(result) {
          if (result.error) {
            showPaymentError(container, result.error.message);
          } else {
            paymentMethod = result.paymentMethod;
            $(".payment-intent-form [name=payment_method_id]").val(result.paymentMethod.id);
            $(".payment-intent-form").submit();
          }
        });
      });

      $(".payment-intent-form").on("ajax:success", function(e, data) {
        if (data.error) {
          showPaymentError(container, data.error)
        } else if (data.success) {
          paymentConfirmed(data.payment_intent_id, paymentMethod);
        } else {
          stripe.handleCardAction(data.payment_intent_client_secret).then(function(result) {
            if (result.error) {
              showPaymentError(container, result.error.message);
            } else {
              paymentConfirmed(result.paymentIntent.id, paymentMethod);
            }
          });
        }
      }).on('ajax:complete', function() {
        container.find(".next-screen").prop("disabled", false);
      });
    }

    function showPaymentError(container, error) {
      container.find(".error-message").text(error);
      container.find(".next-screen").prop("disabled", false);
    }

    function paymentConfirmed(intentId, paymentMethod) {
      $(".rental-form #payment-intent-input").val(intentId);
      $("#tab-summary .payment-summary .card-last4").text(paymentMethod.card.last4);
      openTab('summary');
    }

    function initSummaryScreen() {
      var screen = $("#tab-summary");
      screen.find(".back-to-payment").on("click", function() {
        openTab('payment');
      });

      screen.find(".submit-form").on("click", function() {
        $(".rental-form").submit();
      });
    }

    function openTab(tab) {
      $('.tabs-ctrl').trigger('show', '#tab-' + tab);
      $('.tabs-ctrl').get(0).scrollIntoView();
    }

    return {
      init: init
    };

})();
