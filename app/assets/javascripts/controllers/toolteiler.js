APP.controllers.toolteiler = (function() {

    function init() {
      if ($("section.toolTeiler").exists()) { initToolteilerDetail(); }
      if ($("section.form-rent-toolteiler").exists()) { initToolteilerRent(); }
      if ($("section.form-new-toolteiler").exists()) { initToolteilerCreate(); }
    }

    function initToolteilerDetail() {

      $('.starts_at_date').pickadate({
        formatSubmit: 'yyyy-mm-dd',
        hiddenName: true,
        format: 'ddd, dd mmm, yyyy',
        onSet: function(context) {
          if (typeof context.select !== "undefined") {
            var d = moment(context.select).locale('de').format('l');
            console.log(d);
          }

        }
      });

      $('.ends_at_date').pickadate({
        formatSubmit: 'yyyy-mm-dd',
        hiddenName: true,
        format: 'ddd, dd mmm, yyyy',
        //disable: [
          //{ from: -365, to: request_start_date }
        //]
      });

      var toolTeilerGallery = new jBox('Image', {
        addClass:'jBoxGallery',
        imageCounter:true,
        preloadFirstImage:true,
        closeOnEsc:true,
        createOnInit:true,
        animation:{open: 'zoomIn', close: 'zoomOut'},
      });

      /*

      Integrate jQuery Mobile and listen to swipe-left / swipe-right.
      Click Control Buttons on Swipe.

      $('.jBoxGallery .jBox-content').on('click', function(){
        $('.jBox-image-pointer-next').click();
      });
      */

    }

    function initToolteilerRent() {

      tabsNavActivating();

    }

    function initToolteilerCreate() {

      tabsNavActivating();

      $('#custom-keywords').tagsInput({
        'defaultText':'Kurz in Stichworten ..'
      });

    }

    // Add Active Class to Actual Step
    function tabsNavActivating() {
      var step = $('*[data-step]').attr("data-step");
      $('#step'+step).addClass('active');
    }

    return {
      init: init
    };

})();
