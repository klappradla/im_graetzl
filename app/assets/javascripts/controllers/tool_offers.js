APP.controllers.tool_offers = (function() {

    function init() {
      if ($("section.form-new-toolteiler").exists()) { initToolOfferForm(); }
      if ($("section.toolTeiler-detail").exists()) { initToolOfferDetails(); }
    }

    function initToolOfferForm() {
      APP.components.tabs.initTabs(".tabs-ctrl");
      APP.components.addressSearchAutocomplete();

      $(".next-screen").on("click", function() {
        $('.tabs-ctrl').trigger('show', '#' + $(this).data("tab"));
        $('.tabs-ctrl').get(0).scrollIntoView();
      });

      var subcategoryOptions = $(".subcategory-select option[data-parent-id]").detach();
      $(".category-select").on("change", function() {
        $(".subcategory-select option[data-parent-id]").remove();
        if ($(this).val()) {
          $(".subcategory-select").append(subcategoryOptions.filter("[data-parent-id=" + $(this).val() + "]"));
        }
      }).change();

      // Tag Input JS
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
          $('.-disabled').hide();
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

    return {
      init: init
    };

})();
