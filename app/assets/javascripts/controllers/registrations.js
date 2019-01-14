APP.controllers.registrations = (function() {

    function init() {
      APP.components.inputTextareaMovingLabel();
      APP.components.addressSearchAutocomplete();
      APP.components.graetzlSelect();

      if ($(".register-personalInfo").exists()) {
        initRegistrationForm();
      }

    }

    function initRegistrationForm() {
      $('input[name="user[business]"]').on("change", function() {
        var isBusiness = $('input[name="user[business]"]:checked').val() == 'true';
        $(".user-business").toggle(isBusiness);
      }).change();

      $(".business-interests input").on("change", function() {
        if ($(".business-interests input:checked").length >= 3) {
          $(".business-interests input:not(:checked)").each(function() {
            $(this).prop("disabled", true);
            $(this).parents(".input-checkbox").addClass("disabled");
          });
        } else {
          $(".business-interests input").prop("disabled", false);
          $(".business-interests .input-checkbox").removeClass("disabled");
        }
      });
    }

    return {
        init: init
    }

})();
