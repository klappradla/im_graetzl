APP.controllers.messenger = (function() {

  function init() {
    initThreadFilter();
    initThread();
    initLayout();
    fetchThreadList();

    // initThread Select after Load more Button Click
    $('.link-load').on('ajax:success', function() {
      initThreadSelect();
    });

    // Preselect Filter in Sidebar
    var preselectedFilter = $("#side-bar .threads-list").data("filter");
    if (preselectedFilter) {
      $("#side-bar .filter a[data-filter='" + preselectedFilter + "']").click();
    }

    if (!$("#side-bar .fetch-thread-list-form").find('.loading-spinner').exists()) {
      $("#side-bar .threads-list").hide(); // Hide Threads
      $("#side-bar .fetch-thread-list-form").append(createSpinner()); // Show Spinner
    }

  }


  // Sidebar Threads - Load Thread
  function fetchThreadList() {
    $("#side-bar .fetch-thread-list-form").submit();
    $("#side-bar .fetch-thread-list-form").on("ajax:beforeSend", function() {
      if (!$("#side-bar .fetch-thread-list-form").find('.loading-spinner').exists()) {
        $("#side-bar .threads-list").hide(); // Hide Threads
        $("#side-bar .fetch-thread-list-form").append(createSpinner()); // Show Spinner
        $("#side-bar").find(".more-data").addClass("hide"); // Hide Load More Link
      }
    });

    $("#side-bar .fetch-thread-list-form").on("ajax:success", function() {
      initThreadSelect();
      $("#side-bar .fetch-thread-list-form").find(".loading-spinner").fadeOut(250, function() {
        $(this).remove(); // remove Spinner
        $("#side-bar .threads-list").fadeIn(250); // Show Threads
        $("#side-bar").find(".more-data").removeClass("hide"); // Show Load More Link if moredata exists
      });

      // Preselect Thread in Sidebar
      var preselectedThread = $("#side-bar .threads-list").data("thread");
      if (preselectedThread) {
        $("#side-bar .message-thread[data-id='" + preselectedThread + "']").click();
      }
    });
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

    // Click on Filter Link in Sidebar
    $("#side-bar .filter .jBoxDropdown a").on("click", function() {
      $("#side-bar #filter").val($(this).data("filter")); // Set HiddenField Filter Value
      $("#side-bar #thread_id").val($(this).data("")); // Remove Hidden Field Value for Thread-ID
      $("#side-bar .threads-list").data('thread', ''); // Remove Thread-ID
      $("#filterMessages .selected-filter").text($(this).text());
      fetchThreadList();
    });

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
      APP.components.initUserTooltip();
      $('#message-list .chat-message').linkify({target: "_blank"});
    });

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


  function createSpinner() {
    return $('footer .loading-spinner').clone().removeClass('-hidden');
  }


  function scrollToLastMessage() {
    //$(".chat-panel").scrollTop($(".chat-panel")[0].scrollHeight);
    $('.chat-panel').animate({
      scrollTop:$(".chat-panel")[0].scrollHeight
    }, 500);

  }

  // Layout Init Function
  function initLayout() {
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
