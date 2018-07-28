APP.controllers.groups = (function() {

    function init() {
      if ($(".group-page").exists()) {
        initHeader();
        initInfo();
        initDiscussions();
      }
      if ($(".group-page .categories-list").exists()) {
        initMobileNav();
      }
    }

    function initHeader() {
      APP.components.tabs.initTabs(".tabs-ctrl");

      $(".join-request-button").featherlight({
        root: '#groups-btn-ctrl',
        targetAttr: 'href'
      });

      $(".request-message-opener").featherlight({
        root: '#groups-btn-ctrl',
        targetAttr: 'href'
      });
    }

    function initInfo() {
      $(".all-discussions-link").on("click", function() {
        $(".tabs-ctrl").trigger('show', '#tab-discussions');
      });
    }

    function initDiscussions() {
      $('#tab-discussions .btn-new-topic').on('click', function() {
        $('#new-topic').slideToggle();
      });

      $("#tab-discussions .categories-list a").on("click", function() {
        $(this).parents("li").addClass("selected").siblings("li").removeClass("selected");
      });

      if (window.location.href.indexOf('group_category_id') > -1) {
        var url_string = window.location.href;
        var url = new URL(url_string);
        var category_id = url.searchParams.get("group_category_id");
        // check if link ends with specific group_category_id
        var findCategoryLink = $('.categories-list li a[href$="group_category_id='+category_id+'"]');
        findCategoryLink.click();
      } else {
        $("#tab-discussions .autoload-link").click();
      }
    }

    function initMobileNav() {
      var $dropdown = $(".categories-list-mobile select");
      $(".categories-list li a").each(function() {
              var $this = $(this),
              link = $this.attr('href'),
              txt = $this.text();

          $dropdown.append(getOption());

          function getOption() {
              if($this.hasClass('active'))
                  return '<option selected value="'+ link +'" data-remote="true">'+ txt +'</option>';
              return '<option value="'+ link +'" data-remote="true">'+ txt +'</option>';
          }
      });
      $dropdown.on('change', function() {
        var getLink = $('.categories-list li a[href*="'+$dropdown.val()+'"]');
        getLink.click();
      });
    }

    return {
      init: init
    };

})();
