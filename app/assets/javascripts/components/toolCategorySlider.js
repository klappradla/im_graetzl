APP.components.toolCategorySlider = (function() {

  function init(element) {
    var item_desk = 5;
    var item_tab = 3;
    var item_mob = 1;
    var items = element.find("div").length;

    var slider = element.lightSlider({
      item: item_desk,
      autoWidth: true,
      slideMove: 1, // slidemove will be 1 if loop is true
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
            addClass: '-tablet',
            onBeforeSlide: function (el) {
              //showControls(el.getCurrentSlideCount(), item_tab);
            }
          }
        },
        {
          breakpoint:415,
          settings: {
            item: item_mob,
            controls: false,
            pager: true,
            addClass: '-mobile',
            onBeforeSlide: function (el) {
              //showControls(el.getCurrentSlideCount(), item_mob);
            }
          }
        }
      ],
      onBeforeSlide: function (el) {
        //showControls(el.getCurrentSlideCount(), item_desk);
      }
    });

    //$('.lSPrev').hide(); // hide prev on load

    // Show or Hide Control Buttons
    function showControls(currentCount, itemCount) {
      if (currentCount == 1) {
        $('.lSPrev').hide();
      } else {
        $('.lSPrev').show();
      }
      if (currentCount > (items - itemCount)) {
        $('.lSNext').hide();
      } else {
        $('.lSNext').show();
      }
    }

    // Hover Slide
    element.find('.-category').hover(
     function(){ $(this).addClass('hover') },
     function(){ $(this).removeClass('hover')}
   );

   // Click Slide
   element.find('.-category').on('click', function(){
     var cat_id = $(this).attr("data-cat");
     element.find('.-category').not(this).removeClass('activated');
     $(this).toggleClass('activated');

     // On mobile slide on click
     if ($('.lSSlideOuter').is('.-mobile')) {
       slider.goToSlide(cat_id-1);
     }

   });

  }

  return {
    init: init
  };
})();
