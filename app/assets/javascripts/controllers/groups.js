APP.controllers.groups = (function() {

    function init() {
      if ($(".group-page").exists()) {
        initHeader();
        initInfo();
        initDiscussions();
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

      $("#tab-discussions .autoload-link").click();
    }

    return {
      init: init
    };

})();
