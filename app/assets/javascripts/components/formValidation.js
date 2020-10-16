APP.components.formValidation = (function() {

  function init() {

    // ************ VALIDATE REQUIRED FIELDS ***************** //

    // Validation for Empty Fields if required
    $(".form-block :input.-required").on("blur", function() {
      var $error_msg = $( "<span class='error_msg required_msg'> *</span>" );
      var $label = $("label[for='"+this.id+"']");
      if ($(this).val()) {
        $(this).removeClass('-invalid');
        $label.removeClass('-invalid');
        $label.find('span.error_msg').remove();
      } else {
        $(this).addClass('-invalid');
        $label.addClass('-invalid');
        $label.find('span.error_msg').remove();
        $label.find('span').append($error_msg);
      }
    });

    // Type in empty fields
    $(document).on("keydown", ':input.-required.-invalid', function(e) {
      var $label = $("label[for='"+this.id+"']");
      $(this).removeClass('-invalid');
      $label.removeClass('-invalid');
      $label.find('span.error_msg').remove();
    });


    // ************ BROWSER VALIDATION URL/MAIL/NUMBER ***************** //


    // Browser Validation Form Fields with class "-validate"
    $(".form-block :input.-validate").on("blur", function() {
      var $error_msg = $( "<span class='error_msg'> (Fehler)</span>" );
      var $label = $("label[for='"+this.id+"']");
      if (this.checkValidity()) {
        $(this).removeClass('-invalid');
        $label.removeClass('-invalid');
        $label.find('span.error_msg').remove();
      } else {
        $(this).addClass('-invalid');
        $label.addClass('-invalid');
        $label.find('span.error_msg').remove();
        $label.find('span').append($error_msg);
      }
    });

    // Type in invalid fields
    $(document).on("keyup", ':input.-validate.-invalid', function(e) {
      var $label = $("label[for='"+this.id+"']");
      if (this.checkValidity()) {
        $(this).removeClass('-invalid');
        $label.removeClass('-invalid');
        $label.find('span.error_msg').remove();
      }
    });


  }

  return {
    init: init
  };

})();
