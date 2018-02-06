APP.controllers.sessions = (function() {

    function init() {

        APP.components.inputTextareaMovingLabel();

        $(document).ready(function() {
          // Set FB and Analytics Tracking for new registered Users
          var newRegConfUser = $("#flash .alert");
          if (newRegConfUser.exists()) {
            if( newRegConfUser.html().indexOf('Anmeldedaten') >= 0){
            //if( newRegConfUser.html().indexOf('Dein Account ist nun freigeschaltet') >= 0){
              var reggraetzl;
              reggraetzl = localStorage.getItem('Graetzl');
              console.log(reggraetzl);
              // FB
              fbq('track', 'CompleteRegistration');
              // Analytics
              gtag('event', 'sign_up', {
                'event_category': 'Registration',
                'event_label': reggraetzl
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
