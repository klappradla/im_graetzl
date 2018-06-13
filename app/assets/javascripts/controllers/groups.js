APP.controllers.groups = (function() {

    function init() {
      if ($(".group-page").exists()) {
        initShow();
      }
    }

    function initShow() {
      APP.components.tabs.initTabs(".tabs-ctrl");
      $(".all-discussions-link").on("click", function() {
        $(".tabs-ctrl").trigger('show', '#tab-discussions');
      });
    }

    return {
      init: init
    };

})();
