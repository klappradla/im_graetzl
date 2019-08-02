APP.controllers.tool_offers = (function() {

    function init() {
      if ($("section.form-new-toolteiler").exists()) { initToolOfferForm(); }
      if ($("section.toolTeiler-detail").exists()) { initToolOfferDetails(); }
      if ($("section.form-rent-toolteiler").exists()) { initToolteilerRent(); }
    }

    function initToolOfferForm() {
      APP.components.tabs.initTabs(".tabs-ctrl");
      APP.components.addressSearchAutocomplete();

      $(".next-screen").on("click", function() {
        $('.tabs-ctrl').trigger('show', '#' + $(this).data("tab"));
        $('.tabs-ctrl').get(0).scrollIntoView();
      });

      $(".category-select").on("change", function() {
        $(".subcategory-select option").hide();
        $(".subcategory-select option[data-parent-id=" + $(this).val() + "]").show();
      }).change();

      $('#custom-keywords').tagsInput({
        'defaultText':'Kurz in Stichworten ..'
      });

    }

    function initToolOfferDetails() {
      $('.request-price-form').find(".date-from, .date-to").pickadate({
        hiddenName: true,
        formatSubmit: 'yyyy-mm-dd',
        format: 'ddd, dd mmm, yyyy',
      }).off('focus').on("change", function() {
        if ($('.request-price-form .date-from').val() && $('.request-price-form .date-to').val()) {
          $('.request-price-form').submit();
        }
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

    // Add Active Class to Actual Step
    function tabsNavActivating() {
      var step = $('*[data-step]').attr("data-step");
      $('#step'+step).addClass('active');
    }

    return {
      init: init
    };

})();
