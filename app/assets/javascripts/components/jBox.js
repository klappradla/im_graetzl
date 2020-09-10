APP.components.jBox = (function() {

  // jBox Tooltips for Users
  var user_tooltips = []

  // Desktop Hover Tooltips
  // selector eingrenzen auf .signed-in wenn nur eingeloggt
  $(".no-touch .signed-in .user-tooltip-trigger").each(function(index, value) {

      var tooltip = $(this).data('tooltip-id');
      user_tooltips[tooltip] = new jBox('Tooltip', {
        addClass:'jBox',
        attach: $(this),
        closeOnMouseleave: true,
        delayOpen: 500,
        delayClose: 250,
        position: {
          x: 'center',
          y: 'bottom'
        },
        ajax: {
            reload: false,
            setContent: true,
            spinner:true,
            spinnerReposition:false,
            success: function (response) {
              this.setContent(response);
            }
        },
      });

  });

})();
