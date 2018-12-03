APP.controllers.districts = (function() {

  function init() {
    initMenu();
    initMap();
    initFilter();
    initMobileNav();
    initSlider();
  }

  function initSlider() {
    $(document).ready(function() {
      $("#lightSlider").lightSlider({
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
                    item:2,
                    slideMove:2,
                  }
            },
            {
                breakpoint:530,
                settings: {
                    item:1,
                    slideMove:1
                  }
            }
          ]
      });
    });
  }


  function initMenu() {
    var $select = $(".mapImgBlock .mobileSelectMenu");
    $(".mapImgBlock .links a").each(function() {
      var text = $(this).text();
      var target = $(this).attr("href");
      $select.append("<option value="+target+">"+text+"</option>");
      //$(".mapImgBlock .links").after($select);
    });

    $select.on("change", function() {
      window.location.href = $(this).val();
    });
  }

  function initMap() {
    var map = APP.components.graetzlMap;
    var mapdata = $('#graetzlMapWidget').data('mapdata');
    map.init(function() {
      map.showMapDistrict(mapdata.districts, {
        style: $.extend(map.styles.mint, {
          weight: 0,
          fillOpacity: 0.5
        })
      });
      map.showMapGraetzl(mapdata.graetzls, {
        interactive: true,
        zoomAfterRender: false
      });
    });
  }

  function initFilter() {
    if ($("#filter-modal-bezirk").exists()) {
      APP.components.graetzlSelectFilter.init($("#filter-modal-bezirk"));
    }

    if ($('.cards-filter').exists()) {
      APP.components.cardFilter.init();
    }
  }

  function initMobileNav() {
    var $dropdown = $(".filter-stream .input-select select");
    $(".filter-stream .iconfilter").not('.createentry, .loginlink').each(function() {
        var $this = $(this),
            link = $this.prop('href'),
            txt = $this.find('.txt').text();

        $dropdown.append(getOption());
        $dropdown.on('change', function() {
            document.location.href = $dropdown.val();
        });

        function getOption() {
            if($this.hasClass('active'))
                return '<option selected value="'+ link +'">'+ txt +'</option>';
            return '<option value="'+ link +'">'+ txt +'</option>';
        }

    });
    $('[data-behavior=createTrigger]').jqDropdown('attach', '[data-behavior=createContainer]');
  }

  return {
    init: init
  };

})();
