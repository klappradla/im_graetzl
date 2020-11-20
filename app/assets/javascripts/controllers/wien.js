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

        if($('#graetzlMapWidget:visible').length > 0) {
          initMap();
        }

        if ($("#filter-modal-bezirk").exists()) {
          APP.components.graetzlSelectFilter.init($("#filter-modal-bezirk"));
        }

        if ($("#filter-modal-district").exists()) {
          APP.components.districtSelectFilter.init($("#filter-modal-district"));
        }

        if ($('.cards-filter').exists()) {
          APP.components.cardFilter.init();
        }

        if ($("#card-slider").exists()) {
          APP.components.cardSlider.init($("#card-slider"));
        }

        if ($("section.toolteiler").exists()) {
          APP.components.categorySlider.init($('#category-slider'));
        }

        if ($("section.rooms").exists()) {
          APP.components.categorySlider.init($('#category-slider'));
        }

        if ($("section.meetings").exists()) {
          APP.components.categorySlider.init($('#category-slider'));
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


    return {
      init: init
    };

})();
