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


    // Set Screen Mode Class
    enquire
        .register("screen and (max-width:" + APP.config.majorBreakpoints.medium + "px)", {
            deferSetup : true,
            setup : function() {
              $('body').addClass('mob');
            },
            match : function() {
              $('body').addClass('mob');
              $('body').removeClass('desk');
            }
        })
        .register("screen and (min-width:" + APP.config.majorBreakpoints.medium + "px)", {
            deferSetup : true,
            setup : function() {
              $('body').addClass('desk');
            },
            match : function() {
              $('body').addClass('desk');
              $('body').removeClass('mob');
            }
        });


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

          // Registration
          if ( $("#flash .notice").text().indexOf('Super, du bist nun registriert!') >= 0 ){
            gtag('event', 'sign_up', {'event_category': 'Registration'}); // GA
            gtag('event', 'conversion', {'send_to': 'AW-807401138/zBwECJ738IABELLt_4AD'}); // G-AW
            fbq('track', 'CompleteRegistration'); // FB
          }

          // SignUp Unterstützer-Team
          if ( $("#flash .notice").text().indexOf('Deine Beitrittsanfrage wurde abgeschickt!') >= 0 && document.referrer.indexOf('unterstuetzer-team') >= 0 ){
            fbq('trackCustom', 'UnterstuetzerSignUp');
          }

        }
      });
    }

  }

  // ---------------------------------------------------------------------- Returns

  return {
    init: init
  }

})();
