APP.components.cardSlider = (function() {

  function init(element) {
    $(element).lightSlider({
      item: 3,
      autoWidth: false,
      slideMove: 3, // slidemove will be 1 if loop is true
      slideMargin: 15,
      addClass: '',
      mode: "slide",
      useCSS: true,
      cssEasing: 'ease', //'cubic-bezier(0.25, 0, 0.25, 1)',//
      easing: 'linear', //'for jquery animation',////
      speed: 400, //ms'
      auto: false,
      loop: true,
      slideEndAnimation: true,
      pause: 2000,
      keyPress: false,
      controls: true,
      prevHtml: '',
      nextHtml: '',
      adaptiveHeight:false,
      pager: false,
      //currentPagerPosition: 'middle',
      enableTouch:true,
      enableDrag:false,
      freeMove:true,
      swipeThreshold: 40,
      responsive : [
        {
          breakpoint:850,
          settings: {
            item: 2,
            slideMove: 2,
          }
        },
        {
          breakpoint:530,
          settings: {
            item: 1,
            slideMove: 1
          }
        }
      ]
    });
  }

  return {
    init: init
  };
})();
