APP.controllers.going_tos = (function() {

    function init() {
      if ($(".going-to-page.login-screen").exists()) {
        initLoginScreen();
      } else if ($(".going-to-page.address-screen").exists()) {
        initAddressScreen();
      } else if ($(".going-to-page.payment-screen").exists()) {
        initPaymentScreen();
      } else if ($(".going-to-page.summary-screen").exists()) {
        initSummaryScreen();
      }
    }

    function initLoginScreen() {
      // Change Wording of Notice Message for Ticket Registrations
      if ($("#flash .notice").exists()) {
        var flashText = $("#flash .notice").text();
        if (flashText.indexOf('Super, du bist nun registriert!') >= 0){
          // Modifiy Message for Ticket Registrations
          $("#flash .notice").text(flashText + ' Danach gehts weiter mit deinem Ticket-Kauf.');
        }
      }
    }

    function initAddressScreen() {

      setTab('step1');

      // Change Wording of Notice Message for Ticket Registrations
      if ($("#flash .notice").exists()) {
        var flashText = $("#flash .notice").text();
        if (flashText.indexOf('Vielen Dank für Deine Registrierung.') >= 0){
          // Modifiy Message for Ticket Registrations
          $("#flash .notice").text('Vielen Dank für Deine Registrierung. Du bist jetzt angemeldet und kannst mit deinem Ticket-Kauf fortfahren..');
        }
      }

    }

    function initPaymentScreen() {

      setTab('step2');

      var screen = $(".going-to-page.payment-screen");
        screen.find(".paymentMethods input").on("click", function() {
        screen.find(".payment-method-container").hide();
        screen.find("." + $(this).val() + "-container").show();
      });

      screen.find(".paymentMethods input:checked").click();

      screen.find(".remote-form").on('ajax:before', function() {
        hideFormError($(this));
      }).on('ajax:error', function(e, xhr) {
        var error = xhr.responseJSON && xhr.responseJSON.error;
        error = error || "An error occurred. Please check your connection and try again."
        showFormError($(this), error);
      });

      initCardPayment();
      initKlarnaPayment();
      initEpsPayment();
    }

    function initCardPayment() {
      var container = $(".card-container");
      var nextButton = container.find(".next-screen");
      var nameInput = container.find('#cardholder-name');
      var card = initCardInput();
      var cardReady = false;

      card.mount('#card-element');
      card.addEventListener('change', function(event) {
        if (event.error) {
          showFormError(container, event.error.message);
        } else {
          hideFormError(container);
        }
        cardReady = event.complete;
        checkCreditCard();
      });

      nameInput.on('input', function() {
        checkCreditCard();
      });

      function checkCreditCard() {
        if (cardReady && nameInput.val()) {
          nextButton.removeAttr("disabled");
        } else {
          nextButton.attr("disabled", true);
        }
      }

      var paymentIntentFrom = container.find(".payment-intent-form");

      nextButton.on("click", function() {
        nextButton.attr("disabled", true);
        hideFormError(container);
        stripe.createPaymentMethod('card', card, {
          billing_details: { name: nameInput.val() }
        }).then(function(result) {
          if (result.error) {
            showFormError(container, result.error.message);
            nextButton.removeAttr("disabled");
          } else {
            paymentIntentFrom.find("[name=payment_method_id]").val(result.paymentMethod.id);
            paymentIntentFrom.submit();
          }
        });
      });

      paymentIntentFrom.on("ajax:success", function(e, data) {
        if (data.success) {
          paymentConfirmed(data.payment_intent_id);
        } else {
          stripe.handleCardAction(data.payment_intent_client_secret).then(function(result) {
            if (result.error) {
              showFormError(container, result.error.message);
            } else {
              paymentConfirmed(result.paymentIntent.id);
            }
          });
        }
      }).on('ajax:complete', function() {
        nextButton.removeAttr("disabled");
      });

      function paymentConfirmed(intentId) {
        var nextForm = $(".next-step-form");
        nextForm.find("[name=stripe_payment_intent_id]").val(intentId);
        nextForm.find("[name=payment_method]").val('card');
        nextForm.submit();
      }
    }

    function initCardInput() {
      var elements = stripe.elements({
        fonts: [
          { cssSrc: 'https://fonts.googleapis.com/css?family=Lato:400,400i,300' }
        ]
      });

      var style = {
        base: {
          fontFamily: '"Lato", sans-serif',
          fontWeight: 400,
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

      return elements.create('card', {style: style, hidePostalCode: true, classes: {base: 'input-plain'}});
    }

    function initKlarnaPayment() {
      var container = $(".klarna-container");
      var nextButton = container.find(".next-screen");

      container.find(".klarna-source-form").on("ajax:success", function(e, data) {
        location.href = data.redirect_url;
      });

      if ($('#klarna-payment-success').exists()) {
        $(".next-step-form").submit();
      }
    }

    function initEpsPayment() {
      var container = $(".eps-container");
      var nextButton = container.find(".next-screen");

      container.find(".eps-source-form").on("ajax:success", function(e, data) {
        location.href = data.redirect_url;
      });

      if ($('#eps-payment-success').exists()) {
        $(".next-step-form").submit();
      }
    }

    function showFormError(container, error) {
      container.find(".error-message").text(error);
    }

    function hideFormError(container) {
      container.find(".error-message").text("");
    }

    function initSummaryScreen() {
      setTab('step3');

      var transaction_id = $('#purchase #going_to_id').val();
      var value = $('#purchase #going_to_amount').val();
      var tax = $('#purchase #going_to_tax').val();
      var item_id = $('#purchase #meeting_id').val();
      var item_name = $('#purchase #meeting_name').val();

      gtag('event', 'purchase', {
        transaction_id: transaction_id,
        value: value,
        currency: 'EUR',
        tax: tax,
        items: [
          {
            id: item_id,
            name: item_name,
            price: value,
          }
        ]
      });

      if (window.location.hostname == 'www.imgraetzl.at') {
        fbq('track', 'Purchase',
          {
            value: value,
            currency: 'EUR',
            contents: [
              {
                id: item_id,
                quantity: 1
              }
            ],
          }
        );
      }
    }

    function openTab(tab) {
      $('.tabs-ctrl').trigger('show', '#tab-' + tab);
      $('.tabs-ctrl').get(0).scrollIntoView();
    }

    function setTab(tab) {
      $('.tabs-ctrl li').removeClass('active');
      $('.tabs-ctrl li#'+tab).addClass('active');
    }

    return {
      init: init
    };

})();
