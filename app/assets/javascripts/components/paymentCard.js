APP.components.paymentCard = (function() {
  var card, cardReady;
  var form, nameInput, submitButton;

  function init(submitForm) {
    form = submitForm;
    nameInput = submitForm.find('#cardholder-name');
    submitButton = submitForm.find("#card-submit");

    // Create Stripe Card Input and validate it on change
    card = getCardElement();
    cardReady = false;
    card.mount('#card-element');
    card.addEventListener('change', function(event) {
      if (event.error) {
        showFormError(event.error.message);
      } else {
        hideFormError();
      }
      cardReady = event.complete;
      checkCreditCard();
    });

    nameInput.on('input', function() {
      checkCreditCard();
    });

    // On Submit, create payment method and send it to server to attempt charge
    submitButton.on("click", function() {
      submitButton.attr("disabled", true);
      hideFormError();
      stripe.createPaymentMethod('card', card, {
        billing_details: { name: nameInput.val() }
      }).then(function(result) {
        if (result.error) {
          showFormError(result.error.message);
          submitButton.removeAttr("disabled");
        } else {
          form.find("[name=payment_method_id]").val(result.paymentMethod.id);
          form.submit();
        }
      });
    });

    // Charge can be successful, or it can return with a request for additional authorization.
    form.on("ajax:success", function(e, data) {
      if (data.requires_action) {
        stripe.handleCardAction(data.payment_intent_client_secret).then(function(result) {
          if (result.error) {
            showFormError(result.error.message);
          } else {
            form.find("[name=payment_intent_id]").val(data.payment_intent_id);
            form.submit();
          }
        });
      } else if (data.success) {
        form.trigger('payment:complete');
      }
    }).on('ajax:error', function(e, xhr) {
      var error = xhr.responseJSON && xhr.responseJSON.error;
      error = error || "An error occurred. Please check your connection and try again."
      showFormError(error);
    }).on('ajax:complete', function() {
      submitButton.removeAttr("disabled");
    });
  }

  function getCardElement() {
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

    return elements.create('card', {
      style: style, hidePostalCode: true, classes: {base: 'input-plain'}
    });
  }

  function checkCreditCard() {
    if (cardReady && nameInput.val()) {
      submitButton.removeAttr("disabled");
    } else {
      submitButton.attr("disabled", true);
    }
  }

  function showFormError(error) {
    form.find(".error-message").text(error);
  }

  function hideFormError() {
    form.find(".error-message").text("");
  }

  return {
    init: init
  };

})();
