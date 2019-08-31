APP.controllers.messenger = (function() {

  function init() {
    initThreadFilter();
    initThreadSelect();
    initThread();
    initLayout();
  }

  function initThreadFilter() {
    var filterMessages = new jBox('Tooltip', {
      addClass:'jBox',
      attach: '#filterMessages',
      content: $('#jBoxFilterMessages'),
      trigger: 'click',
      closeOnClick:true,
      pointer:'left',
      adjustTracker:true,
      isolateScroll:true,
      adjustDistance: {top: 25, right: 25, bottom: 25, left: 25},
      animation:{open: 'zoomIn', close: 'zoomOut'},
      maxHeight:500,
    });

    $("#side-bar .filter .jBoxDropdown a").on("click", function() {
      $("#side-bar .message-thread").addClass('hidden');
      $("#side-bar .message-thread." + $(this).data("filter")).removeClass('hidden');
      $("#filterMessages .selected-filter").text($(this).text());
    });

    var preselectedFilter = $("#side-bar .threads-list").data("filter");
    if (preselectedFilter) {
      $("#side-bar .filter a[data-filter='" + preselectedFilter + "']").click();
    }
  }

  function initThreadSelect() {
    // Load thread on Click
    $("#side-bar .message-thread").on("click", function() {
      if ($(this).hasClass("-active") || $(this).hasClass("hidden")) return;
      $(this).find(".fetch-form").submit();
      $("#side-bar .message-thread").removeClass("-active");
      $(this).addClass("-active");
    });

    $("#side-bar .fetch-form").on("ajax:complete", function() {
      $("#chat-container").addClass("show-messages");
      scrollToLastMessage();
      history && history.replaceState({}, '', location.pathname + "?thread_id=" + $(".chat-panel").data("thread-id"));
    });

    var preselectedThread = $("#side-bar .threads-list").data("thread");
    if (preselectedThread) {
      $("#side-bar .message-thread[data-id='" + preselectedThread + "']").click();
    }
  }

  function initThread() {
    $("#main-content").on("ajax:complete", ".post-message-form", function() {
      $(this).find(".chat-message-input").val("");
      scrollToLastMessage();
    });

    setInterval(function() {
      $("#main-content .fetch-new-messages-form").submit();
    }, 10*1000);
  }

  function scrollToLastMessage() {
    $(".chat-panel").scrollTop($(".chat-panel")[0].scrollHeight);
  }

  function initLayout() {
    // ------ Load Init Functions
    $('footer').hide(); // Disable Footer for Turn-Off Body Scrolling and better Height Calc
    unscroll(); // Prevent Body Scrolling on Desktop
    setWindowHeight(); // Set Exact Browser vh

    $( window ).resize(function() {
      setWindowHeight();
    });

    $('#main-content').on("click", '.back-btn', function() {
      $("#chat-container").removeClass("show-messages");
      $("#side-bar .message-thread").removeClass("-active");
      history && history.replaceState({}, '', location.pathname);
      return false;
    });
  }

  function setWindowHeight() {
    var vh = window.innerHeight * 0.01; // Needed for Exactly Mobile Height
    document.documentElement.style.setProperty('--vh', vh+'px');
  }

  return {
    init: init
  };

})();
