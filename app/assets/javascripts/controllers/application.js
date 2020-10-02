APP.controllers.application = (function() {

  function init() {

    APP.components.headerNavigation.init();
    APP.components.stream.init();

    FastClick.attach(document.body);

    window.cookieconsent_options = {
      "message":"Diese Website verwendet Cookies. Indem Sie weiter auf dieser Website navigieren, stimmen Sie unserer Verwendung von Cookies zu.",
      "dismiss":"OK!","learnMore":"Mehr Information",
      "link":"https://www.imgraetzl.at/info/datenschutz",
      "theme": false
    };

    // Get Target for Mandrill Linking
    $(window).on("load", function() {
      setTimeout(scrollToTarget, 250)
    });

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

    function scrollToTarget() {
      var target = getUrlVars()["target"];
      if (typeof target !== 'undefined') {
        $('html, body').animate({
          scrollTop: $('#'+target).offset().top
        }, 600);
      }
    }

    function getUrlVars() {
      var vars = {};
      var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
          vars[key] = value;
      });
      return vars;
    }

  }

  // ---------------------------------------------------------------------- Returns

  return {
    init: init
  }

})();
