APP.components.mainNavigation = (function() {

    var $mobileNavTrigger, $mainNavHolder, $mobileNavHolder, $mobileMainNav, $dropdownTriggers, $notificationList;

    function init() {

        $scrollableIconNav = $('.-scrollnav.overthrow');
        $mobileNavTrigger =  $('.mobileNavToggle');
        $mainNavHolder =  $(".mainNavHolder");
        $mobileNavHolder = $(".mobileNavHolder");
        $dropdownTriggers = $(".graetzlTrigger, .wienTrigger, .dropdownTrigger, .usersettingsTrigger");
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
                    $(".wienTrigger").jqDropdown('attach', '.wienContainer');
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

        $(".searchTrigger").on("click", function() {
            setTimeout(function() { $("header .search-form #q").focus(); }, 200);
        });

        $(document).on("closeAllTopnav", function() {
            closeMobileNav();
        });


        // Slide in Menue
        var personalNavWidth = $('.usersettingsContainer section.personal').width();
        $('.usersettingsContainer section.second').css('left', personalNavWidth);
        $('.mobileNavHolder section.second').css('left', '100%');

        //Desktop
        $('.usersettingsContainer .main a.-trigger').on('click', function(){
          var personalNavType = 'section.' + $(this).data("type");
          $('.usersettingsContainer ' + personalNavType ).animate({ "left": "0px" }, 250 );
        });
        //Mobile
        $('.mobileNavHolder .main a.-trigger').on('click', function(){
          var navType = 'section.' + $(this).data("type");
          var navTypeHeight = $('.mobileNavHolder ' + navType).height();
          $('.mobileNavHolder ' + navType ).animate({ "left": "0px" }, 250 );
          $(this).closest('.-wrapper').animate({ "height": navTypeHeight }, 250 );
        });

        // Close Desktop
        $('.usersettingsContainer .second a.-trigger').on('click', function(){
          var personalNavType = 'section.' + $(this).data("type");
          $('.usersettingsContainer ' + personalNavType ).animate({ "left": personalNavWidth }, 200 );
        });
        // Close Mobile
        $('.mobileNavHolder .second a.-trigger').on('click', function(){
          var personalNavType = 'section.' + $(this).data("type");
          $('.mobileNavHolder ' + personalNavType ).animate({ "left": '100%' }, 200 );
          var parentMainHeight = $(this).closest('div').find('.main').height();
          $(this).closest('.-wrapper').animate({ "height": parentMainHeight }, 250 );
        });
        // End

    }

    function createMobileNav() {
        $mobileMainNav = $mobileNavHolder.find(".mobileMainNav");
        $mobileNavTrigger.on("click", function() {
            if ($mobileMainNav.hasClass("is-open")) closeMobileNav();
            else openMobileNav();
        });

        if ($scrollableIconNav.find('.active').exists()) {
          scrollableIconNav();
        }

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

    // Scroll to Active Icon
    function scrollableIconNav() {
      var clickedIconPosition = $scrollableIconNav.find('.active').position();
      //$scrollableIconNav.scrollLeft(clickedIconPosition.left-10);
      $scrollableIconNav.animate( { scrollLeft: clickedIconPosition.left-10 }, 750);

      // Add Sticky Class
      $(window).bind('scroll', function() {
        if ($(window).scrollTop() > $('header').height()) {
          $scrollableIconNav.addClass('fixed');
        }
        else {
          $scrollableIconNav.removeClass('fixed');
        }
      });

    }

    return {
        init: init
    }

})();
