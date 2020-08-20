APP.components.categorySlider = (function() {

  function init(element) {
    var item_desk = 5;
    var item_tab = 3;
    var item_mob = 2;
    var items = element.find("div").length;

    var filterForm = $(".cards-filter");
    var filterLine = $(".filter-line");
    var categorylink = filterForm.find('.category-slider-label');

    var slider = element.lightSlider({
      item: item_desk,
      autoWidth: false,
      slideMove: item_desk, // slidemove will be 1 if loop is true
      slideMargin: 15,
      addClass: '',
      mode: "slide",
      useCSS: true,
      cssEasing: 'ease', //'cubic-bezier(0.25, 0, 0.25, 1)',//
      easing: 'linear', //'for jquery animation',////
      speed: 750, //ms'
      auto: false,
      loop: false,
      rtl:false,
      slideEndAnimation: true,
      pause: 15000,
      keyPress: false,
      controls: true,
      pager: false,
      prevHtml: '',
      nextHtml: '',
      adaptiveHeight:false,
      currentPagerPosition: 'middle',
      enableTouch:true,
      enableDrag:false,
      freeMove:true,
      swipeThreshold: 40,
      pauseOnHover: true,
      addClass: '-desktop',
      responsive : [
        {
          breakpoint:850,
          settings: {
            item: item_tab,
            slideMove: item_tab,
            addClass: '-tablet',
          }
        },
        {
          breakpoint:415,
          settings: {
            item: item_mob,
            slideMove: item_mob,
            controls: false,
            pager: true,
            addClass: '-mobile',
          }
        }
      ]
    });

    // Hover Slide
    element.find('.-category').hover(
     function(){ $(this).addClass('hover') },
     function(){ $(this).removeClass('hover')}
   );

   //filterForm.hide(); // Hide per default - Show on Category Click
   //filterLine.hide(); // Hide per default - Show on Category Click

   // Click Slide
   element.find('.-category').on('click', function(){
     if ($(this).hasClass("activated")) {

       $(this).removeClass('activated');
       filterForm.find("[name=category_id]").val("");
       filterForm.find("[name=special_category_id]").val("");
       updateFilterLabels($(this));
       filterForm.submit();
       //filterForm.slideUp("fast");
       //filterForm.removeClass("-open");
       //filterLine.slideUp();

     } else {

       if ($(this).hasClass("-special-category")) {
         // Special Filter Selected
         filterForm.find("[name=category_id]").val("");
         filterForm.find("[name=special_category_id]").val($(this).attr("data-id"));
       } else {
         // Normal Filter Selected
         filterForm.find("[name=special_category_id]").val("");
         filterForm.find("[name=category_id]").val($(this).attr("data-id"));
       }

       element.find('.-category').removeClass('activated');
       $(this).addClass('activated');
       updateFilterLabels($(this));
       filterForm.submit();
       //filterLine.slideDown();
       //filterForm.addClass("-open"); // Search and District Filter vorübergehend deaktiviert
       //filterForm.slideDown("fast"); // Search and District Filter vorübergehend deaktiviert

     }
   });

   // Update Text Label if exists on Page
   function updateFilterLabels(category) {
     if (typeof categorylink !== "undefined") {
         if (category.hasClass("activated")) {
           var label = category.attr("data-label");
           categorylink.text(label);
         } else {
           categorylink.text(categorylink.data("no-filter-label"));
         }
     }
   }
   // Update Text Label if exists on Page

  }

  return {
    init: init
  };
})();
