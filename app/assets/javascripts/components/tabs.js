APP.components.tabs = (function() {

    function initTabs(tabgroup) {
        $(tabgroup).tabslet({
            animation: false,
            deeplinking: true,
            active: getFirstNotEmptyTab(tabgroup)
        });
    }


    function getFirstNotEmptyTab(tabgroup) {
        var active = 1;
        $(tabgroup).find('[id^="tab-"]').each(function() {
            if(!$(this).find(".defaultText").exists()) {
                active = $(this).index();
                return false;
            }
        });
        return active;
    }

    return {
        initTabs: initTabs
    }

})();
