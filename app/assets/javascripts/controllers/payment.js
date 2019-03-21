APP.controllers.payment = (function() {

  function init() {
    APP.components.stripeCheckout.init();
    if($('.triggerBillingInformation').exists()) initBillingInformation();
  }

  function initBillingInformation() {
    $('.triggerBillingInformation').on('click', function(){
      $(this).next().slideToggle();
    })
  }

  return {
    init: init
  };

})();
