APP.controllers.wien = (function() {

    var map = APP.components.graetzlMap;

    function init() {
        var $select = $(".mapImgBlock .mobileSelectMenu");
        $(".mapImgBlock .links a").each(function() {
            var text = $(this).text();
            var target = $(this).attr("href");
            $select.append("<option value="+target+">"+text+"</option>");
        });
        $select.on("change", function() {
            window.location.href = $(this).val();
        });

        APP.components.addressSearchAutocomplete();

        if ($("#graetzlMapWidget").exists()) {
          initMap();
        }

        if ($("#filter-modal-bezirk").exists()) {
          APP.components.graetzlSelectFilter.init($("#filter-modal-bezirk"));
        }

        if ($('.cards-filter').exists()) {
          APP.components.cardFilter.init();
        }

        if ($("#card-slider").exists()) {
          APP.components.cardSlider.init($("#card-slider"));
        }

        if ($("section.toolteiler").exists()) {
          initToolTeiler();
        }

        initMobileNav();
    }

    function initMap() {
        var mapdata = $('#graetzlMapWidget').data('mapdata');
        map.init(function() {
            map.showMapDistrict(mapdata.districts, {
                interactive: true
            });
        });
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

    function initToolTeiler() {

      var item_desk = 5;
      var item_tab = 3;
      var item_mob = 1;
      var items = $('#category-slider div').length;

      var slider = $('#category-slider').lightSlider({
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
      $('#category-slider .-category').hover(
       function(){ $(this).addClass('hover') },
       function(){ $(this).removeClass('hover')}
     );

     // Click Slide
     $('#category-slider .-category').on('click', function(){
       var cat_id = $(this).attr("data-cat");
       $('#category-slider .-category').not(this).removeClass('activated');
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
