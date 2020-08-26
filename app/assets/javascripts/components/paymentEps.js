APP.components.paymentEps = (function() {
  var form, nameInput, submitButton;

  function init(submitForm) {
    form = submitForm;
    nameInput = submitForm.find('#eps-name');
    submitButton = submitForm.find("#eps-submit");

    form.on("submit", function() {
      submitButton.attr("disabled", true);
      hideFormError();
    });

    form.on("ajax:success", function(e, data) {
      // EPS requires redirect to their site
      stripe.confirmEpsPayment(data.payment_intent_client_secret, {
        payment_method: { billing_details: { name: nameInput.val() } },
        return_url: form.data("complete-url"),
      }).then(function(result) {
        if (result.error) {
          showFormError(error);
        }
      });
    }).on('ajax:error', function(e, xhr) {
      var error = xhr.responseJSON && xhr.responseJSON.error;
      error = error || "An error occurred. Please check your connection and try again."
      showFormError(error);
    }).on('ajax:complete', function() {
      submitButton.removeAttr("disabled");
    });
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
