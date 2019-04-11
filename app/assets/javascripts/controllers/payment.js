APP.controllers.payment = (function() {

  function init() {
    APP.components.stripePayment.init();
    if($('.triggerBillingInformation').exists()) initBillingInformation();
    if($('.payment-selection').exists()) initPaymentMethod();
    if($('textarea#message').exists()) initPaymentMessage();
  }

  function initBillingInformation() {
    $('.triggerBillingInformation').on('click', function(){
      $(this).next().slideToggle();
    })
  }

  function initPaymentMethod() {
    var selectedOption = $("#stripeForm input[type='radio']:checked").val();
    $('#'+selectedOption).show();

    $("input[name='payment_method']").change(function(){
        $(".payment-method").hide();
        $('#'+this.value).show();
    });
  }

  function initPaymentMessage() {
    var maxlength = 500;
    $("textarea#message").on("propertychange input", function() {
      if (this.value.length > maxlength) {
          this.value = this.value.substring(0, maxlength);
      }
    });
  }

  return {
    init: init
  };

})();
