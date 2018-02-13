APP.controllers.registrations = (function() {

    function init() {

        APP.components.inputTextareaMovingLabel();
        APP.components.addressSearchAutocomplete();
        APP.components.graetzlSelect();

        // Set Registration Graetzl In Local Storage (for GA Event Tracking)
        $(document).ready(function() {
          $('#btn-register').on('click', function() {
            var form = $(this).parents("form");
            var graetzl = form.data("graetzl");
            var zip = form.data("zip");
            localStorage.setItem('Graetzl', graetzl + ' ' + zip);
          });
        });

    }


// ---------------------------------------------------------------------- Public

    return {
        init: init
    }

})();
