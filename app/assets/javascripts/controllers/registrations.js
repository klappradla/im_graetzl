APP.controllers.registrations = (function() {

    function init() {

        APP.components.inputTextareaMovingLabel();
        APP.components.addressSearchAutocomplete();
        APP.components.graetzlSelect();

        // Set Registration Graetzl In Local Storage (for GA Event Tracking)
        $(document).ready(function() {
          $('#btn-register').on('click', function() {
            var graetzl = $('#graetzl').html();
            graetzl = graetzl.replace('&amp;','&');
            localStorage.setItem('Graetzl', graetzl);
          });
        });

    }


// ---------------------------------------------------------------------- Public

    return {
        init: init
    }

})();
