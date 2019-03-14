APP.components.notificatonCenter = (function() {
    var DROPDOWN_OPEN = '.jq-dropdown-open',
        $notificationsContainer,
        $notificationsTrigger;

    function init() {
        $notificationsContainer = $("[data-behavior='notifications-container']");
        $notificationsTrigger = $("[data-behavior='notifications-trigger']");
        $(window).load(function() {
            if ($notificationsContainer.exists()) setup();
        });
    }

    function setup() {
        $notificationsTrigger.click(handleClick);
        updateLoop();
    }

    function updateLoop() {
        setTimeout(function() {
            if (notificationCenterOpen()) {
                updateLoop();
            } else {
                pollServer(updateLoop);
            }
        }, APP.config.notificationPollInterval);
    }

    function handleClick() {
        if (!notificationCenterOpen()) {
            showNotificationSpinner();
            pollServer(markAsSeen)
        }
    }

    function pollServer(onSuccessCallback) {
        $.ajax({
            url: "/notifications",
            dataType: "script",
            type: "GET",
            success: function() {
                removeNotificationSpinner();
                onSuccessCallback();
            }
        });
    }

    function markAsSeen() {
        $.ajax({
            url: "/notifications/mark_as_seen",
            dataType: "script",
            type: "POST",
            data: {ids: currentNotificationIds()}
        });
    }

    function currentNotificationIds() {
        var $notificationItems = $("[data-behavior='notification-item']");
        var notificationIds = [].map.call($notificationItems, function(obj) {
            return obj['id'].replace(/notifications_\w*_/, '');
        });
        return JSON.stringify(notificationIds);
    }

    function notificationCenterOpen() {
      return $notificationsTrigger.hasClass(DROPDOWN_OPEN) ? true : false;
    }

    function showNotificationSpinner() {
      var spinner = $('footer .loading-spinner').clone().removeClass('-hidden');
      $('.nav-notifications').append(spinner);
    }

    function removeNotificationSpinner() {
      $('.nav-notifications .loading-spinner').remove();
    }

    return {
        init: init
    }

})();
