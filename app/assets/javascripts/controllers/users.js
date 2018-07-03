APP.controllers.users = (function() {

    function init() {
        APP.components.tabs.initTabs(".tabs-ctrl");
        APP.components.notificationSettings.init();

        if ($("section.userprofile").exists()) {
          $('.autosubmit-stream').submit();
        }
        if ($("section.rooms").exists()) {
          APP.components.cardBox.moveActionCard3rd();
        }

        $('[data-behavior=actionTrigger]').on('click', function(){
          var id = $(this).attr("data-id");
          $(this).jqDropdown('attach', '[data-behavior=actionContainer-'+id+']');
        });

    }

    return {
        init: init
    }

})();
