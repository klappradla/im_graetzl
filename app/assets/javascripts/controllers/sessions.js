APP.controllers.sessions = (function() {

    function init() {

        APP.components.inputTextareaMovingLabel();

        $(document).ready(function() {
          // Set FB and Analytics Tracking for new registered Users
          var newRegConfUser = $("#flash .alert");
          if (newRegConfUser.exists()) {
            if( newRegConfUser.html().indexOf('Dein Account ist nun freigeschaltet') >= 0){
              var reggraetzl = localStorage.getItem('Graetzl');
              // FB
              fbq('track', 'CompleteRegistration');
              // Analytics
              gtag('event', 'Registration', {
                'event_category': reggraetzl
              });
            }
          }
        });

    }


// ---------------------------------------------------------------------- Public

    return {
        init: init
    }

})();
