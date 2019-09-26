APP.controllers.application = (function() {

  function init() {

    APP.components.mainNavigation.init();
    APP.components.stream.init();
    APP.components.notificatonCenter.init();

    FastClick.attach(document.body);

    window.cookieconsent_options = {
      "message":"Diese Website verwendet Cookies. Indem Sie weiter auf dieser Website navigieren, stimmen Sie unserer Verwendung von Cookies zu.",
      "dismiss":"OK!","learnMore":"Mehr Information",
      "link":"https://www.imgraetzl.at/info/datenschutz",
      "theme": false
    };

    // TODO: this is a hack! stuff should come from DB
    function injectSponsorCard() {

      var $markup = $('<div class="cardBox"></div>');

      if(APP.utils.URLendsWith('/stuwerviertel') && APP.utils.isLoggedIn()) {
        $('.card-grid .cardBox').eq(2).after($markup);
      }
      if(APP.utils.URLendsWith('/stuwerviertel') && !APP.utils.isLoggedIn()) {
        $('main').append($markup);
      }
    }

    // Conversion Tracking
    if (window.location.hostname == 'www.imgraetzl.at') {
      $(document).ready(function() {
        if ($("#flash .notice").exists()) {
          if ( $("#flash .notice").text().indexOf('Super, du bist nun registriert!') >= 0 ){
            // GA
            gtag('event', 'sign_up', {'event_category': 'Registration'});
            // G-AW
            gtag('event', 'conversion', {'send_to': 'AW-807401138/zBwECJ738IABELLt_4AD'});
            // FB
            fbq('track', 'CompleteRegistration');
          }
        });
      }
    }

  // ---------------------------------------------------------------------- Returns

  return {
    init: init
  }

})();
