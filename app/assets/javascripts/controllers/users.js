APP.controllers.users = (function() {

    function init() {
        APP.components.tabs.initTabs(".tabs-ctrl");
        APP.components.notificationSettings.init();

        // User Profile
        if ($("section.userprofile").exists()) {
          $('.autosubmit-stream').submit();
          $('.userContent .col2').linkify({ target: "_blank"});
          if (!$(".tabs-nav li").exists()) { $(".tabs-ctrl").hide(); } // Hide Taby if empty
        }

        if ($("section.usersetup").exists()) {
          addActionCard();
        }

        function addActionCard() {
          if ($(".action-card-container").exists()) {
            var actionCard = $(".action-card-container").children().first().clone();
            var cardGrid = $('.cardBoxCollection');
            if (cardGrid.children(":eq(1)").exists()) {
              cardGrid.children(":eq(1)").after(actionCard);
            } else {
              cardGrid.append(actionCard);
            }
          }
        }

    }

    return {
        init: init
    }

})();
