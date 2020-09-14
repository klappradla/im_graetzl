APP.components.headerNavigation = (function() {

  function init() {
    var container = $(".navigation");

    container.find("[data-dropdown]").on('click', function() {
      isDesktop() ? toggleDesktopMenu($(this)) : toggleMobileMenu($(this));
    });

    container.find("[data-submenu]").on("click", function() {
      showSubmenu($(this));
    });

    function toggleDesktopMenu(menuLink) {
      var menu = $('#' + menuLink.data('dropdown'));
      if (menu.hasClass('jq-dropdown')) return;
      menuLink.jqDropdown('attach', '#' + menu.attr('id'));
      menu.addClass("jq-dropdown jq-dropdown-tip jq-dropdown-relative");
      menu.addClass("jq-dropdown-anchor-" + menuLink.data("anchor") || "left");
      menu.wrapInner("<div class='jq-dropdown-panel'></div>");
      menu.jqDropdown('show');
      menu.one('hide', function() {
        menu.find(".jq-dropdown-panel").contents().unwrap();
        menu.removeClass("jq-dropdown jq-dropdown-tip jq-dropdown-relative");
        menu.removeClass("jq-dropdown-anchor-" + menuLink.data("anchor") || "left");
        menuLink.jqDropdown('detach', '#' + menu.attr('id'));
      });
    }

    function toggleMobileMenu(menuLink) {
      var menu = $('#' + menuLink.data('dropdown'));
      if (menuLink.hasClass("is-open")) {
        menuLink.removeClass("is-open");
        menu.removeClass("mobile-dropdown");
      } else {
        container.find(".is-open").removeClass("is-open");
        menuLink.addClass("is-open");
        container.find(".mobile-dropdown").removeClass("mobile-dropdown");
        menu.addClass("mobile-dropdown").appendTo(container);
      }
    }

    function showSubmenu(menuLink) {
      var submenu = $('#' + menuLink.data('submenu'));
      menuLink.parents(".nav-dropdown-menu").find(".nav-dropdown-submenu.shown").removeClass("shown");
      submenu.addClass("shown");
      submenu.find(".nav-load-form").submit();
    }

    // Notifications

    var notificationFetch = container.find("#notifications-fetch");
    var notificationCounter = container.find("#notifications-count");
    if (notificationCounter.length) {
      setInterval(fetchNotificationCount, APP.config.notificationPollInterval);
    }

    container.find(".nav-user-notification-link").on("click", function() {
      if (!notificationFetch.hasClass('active')) return;
      notificationFetch.submit();
    });

    notificationFetch.on("ajax:beforeSend", function() {
      createSpinner().insertBefore(notificationFetch);
      notificationFetch.removeClass("active");
    }).on('ajax:complete', function() {
      container.find("#nav-user-notifications .loading-spinner").remove();
    }).on('ajax:error', function() {
      notificationFetch.addClass("active");
    });

    function fetchNotificationCount() {
      $.get(notificationCounter.data("url"), function(data) {
        if (data.count > 0) {
          notificationCounter.find(".icon-badge").text(data.count);
          notificationFetch.addClass("active");
        } else {
          notificationCounter.find(".icon-badge").text('');
        }
      });
    }
  }

  function isDesktop() {
    return window.innerWidth >= 980;
  }

  function createSpinner() {
    return $('footer .loading-spinner').clone().removeClass('-hidden');
  }

  return {
    init: init
  }

})();
