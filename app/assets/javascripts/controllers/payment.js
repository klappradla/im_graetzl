APP.controllers.payment = (function() {

  function init() {
    APP.components.stripePayment.init();
    if($('.triggerBillingInformation').exists()) initBillingInformation();
    if($('.payment-selection').exists()) initPaymentMethod();
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

  return {
    init: init
  };

})();
