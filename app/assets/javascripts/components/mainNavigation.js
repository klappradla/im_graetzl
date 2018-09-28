APP.components.mainNavigation = (function() {

    var $mobileNavTrigger, $mainNavHolder, $mobileNavHolder, $mobileMainNav, $dropdownTriggers, $notificationList;

    function init() {

        $mobileNavTrigger =  $('.mobileNavToggle');
        $mainNavHolder =  $(".mainNavHolder");
        $mobileNavHolder = $(".mobileNavHolder");
        $dropdownTriggers = $(".graetzlTrigger, .dropdownTrigger, .usersettingsTrigger");
        $notificationList = $(".nav-notifications .notifications");

        enquire
            .register("screen and (max-width:" + APP.config.majorBreakpoints.large + "px)", {
                deferSetup : true,
                setup : function() {
                    createMobileNav();
                }
            })
            //mobile mode
            .register("screen and (max-width:" + APP.config.majorBreakpoints.medium + "px)", {
                deferSetup : true,
                setup : function() {
                    $(document).on("closeAllTopnav", function() {
                        $dropdownTriggers.each(function() {
                            closeMobileNotifications($(this));
                        });
                    });
                },
                match : function() {
                    bindMobileEvents();
                    $mobileNavHolder.find(".nav-notifications").append($notificationList);
                },
                unmatch: function() {
                    unbindMobileEvents();
                    $(document).trigger('closeAllTopnav');
                }
            })
            //desktop mode
            .register("screen and (min-width:" + APP.config.majorBreakpoints.medium + "px)", {
                deferSetup : true,
                setup : function() {
                    $(".graetzlTrigger").jqDropdown('attach', '.graetzlContainer');
                    $(".notificationsTrigger").jqDropdown('attach', '.notificationsContainer');
                    $(".usersettingsTrigger").jqDropdown('attach', '.usersettingsContainer');
                    $(".createTrigger").jqDropdown('attach', '.createContainer');
                    $(".searchTrigger").jqDropdown('attach', '.searchContainer');
                },
                match : function() {
                    $dropdownTriggers.jqDropdown('enable');
                    $mainNavHolder.find(".nav-notifications").append($notificationList);
                },
                unmatch: function() {
                    $dropdownTriggers.jqDropdown('disable');
                    $dropdownTriggers.jqDropdown('hide');
                }
            });

        $(document).on("closeAllTopnav", function() {
            closeMobileNav();
        });
    }

    function createMobileNav() {
        $mobileMainNav = $mobileNavHolder.find(".mobileMainNav");
        $mobileNavTrigger.on("click", function() {
            if ($mobileMainNav.hasClass("is-open")) closeMobileNav();
            else openMobileNav();
        });
    }

    function openMobileNav() {
        $(document).trigger('closeAllTopnav');
        $mobileNavTrigger.addClass("is-open");
        $mobileMainNav.addClass("is-open");
    }

    function closeMobileNav() {
        $mobileNavTrigger.removeClass("is-open");
        $mobileMainNav.removeClass("is-open");
    }


    function bindMobileEvents() {
        $dropdownTriggers.on('click', function() {
            var $this = $(this);
            if ($this.hasClass("is-open")) {
                closeMobileNotifications($this);
            } else {
                openMobileDropdown($this);
            }
        })
    }
    function unbindMobileEvents() {
        $dropdownTriggers.off('click');
    }

    function openMobileDropdown($ele) {
        $(document).trigger("closeAllTopnav");
        var id = $ele.attr("data-mobileNavID");
        $ele.addClass("is-open");
        $(".mobileNavHolder [data-mobileNavID="+id+"]").addClass("is-open");
    }

    function closeMobileNotifications($ele) {
        var id = $ele.attr("data-mobileNavID");
        $ele.removeClass("is-open");
        $(".mobileNavHolder [data-mobileNavID="+id+"]").removeClass("is-open");
    }

    return {
        init: init
    }

})();
