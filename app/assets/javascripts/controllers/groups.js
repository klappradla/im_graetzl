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

      // Toggle Button for new Topic
      $('.btn-new-topic').on( 'click', function() {
        $('#new-topic').slideToggle();
      });

      //$('.introtxt .txt').linkify({ target: "_blank"});

      // JS Action Button Dropdown 
      $('[data-behavior=createTrigger]').jqDropdown('attach', '[data-behavior=createContainer]');

    }

    return {
      init: init
    };

})();
