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
      // Toggle Button for new Topic
      $('.btn-new-topic').on('click', function() {
        $('#new-topic').slideToggle();
      });
    }

    return {
      init: init
    };

})();
