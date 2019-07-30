APP.components.tabs = (function() {

    function initTabs(tabgroup) {
      $(tabgroup).tabslet({
        animation: false,
        active: getFirstNotEmptyTab(tabgroup)
      });
    }


    function getFirstNotEmptyTab(tabgroup) {
      if (window.location.hash && $(window.location.hash).length) {
        return $(tabgroup).find('[id^="tab-"]').index($(window.location.hash)) + 1;
      } else {
        return 1;
      }
    }

    return {
      initTabs: initTabs
    }

})();
