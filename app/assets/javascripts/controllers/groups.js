APP.controllers.groups = (function() {

    function init() {
      if ($(".group-page").exists()) { initShow(); }
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

      // JS Action Button Dropdown for Groups
      $('[data-behavior=actionTrigger]').on('click', function( event ){
        event.preventDefault();
        var id = $(this).attr("data-id");
        $(this).jqDropdown('attach', '[data-behavior=actionContainer-'+id+']');
      });

      $(".-action").mouseenter(function(){
        $(this).find('.top-ico').addClass('-active');
      });
      $(".-action").mouseleave(function(){
        $(this).find('.top-ico').removeClass('-active');
      });

      // Action Dot-Dot-Dot Dropdown on Members Page
      $( "a.-action" ).on('click', function() {
        var id = $(this).attr("data-id");
        $(this).jqDropdown('attach', '[data-behavior=actionContainer-'+id+']');
      });
    }

    return {
      init: init
    };

})();
