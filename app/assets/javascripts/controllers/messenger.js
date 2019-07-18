APP.controllers.messenger = (function() {

  function init() {
    initMessenger();
    initJBox();
  }

  function initMessenger() {

    // ------ Load Init Functions
    $('footer').hide(); // Disable Footer for Turn-Off Body Scrolling and better Height Calc
    unscroll(); // Prevent Body Scrolling on Desktop
    setWindowHeight(); // Set Exact Browser vh
    scrollToLastMessage();

    $( window ).resize(function() {
      setWindowHeight();
    });

    // ------ Functions

    // Jump to end of Chat Messages -> Show newest.
    function scrollToLastMessage() {
      $(".chat-panel").scrollTop($(".chat-panel")[0].scrollHeight);
    }

    var msg = '1';
    var loading_bubbles = false;
    var numberMessages = 5;
    var insert_fake_content = $('.fake'+msg+' .chatMsg:nth-child(-n+'+numberMessages+')'); // Fake Clone Content
    var loadedBubbleHeight = 0;
    var loading_spinner_height = 0;

    // When scrolling to top of Chat Messages -> Load older before
    $(".chat-panel").bind('scroll', function(e) {

      var elem = $(e.currentTarget);

      if (elem.scrollTop() < 0 && loading_bubbles == false) {
        loading_bubbles = true;
        //console.log("top rechaed"); // Check for older Messages and load them
        $('.loading-spinner').clone().insertBefore('.chatMsg:first').hide().fadeIn('200', function(){
          setTimeout(function() { // Animate Time for Ajax
            loading_spinner_height = $('.chat-panel .loading-spinner').outerHeight(true);
            $('.chat-panel .loading-spinner').remove();

            // Demo Bubbles for loading more content ...
            insert_fake_content.clone().insertBefore('.chatMsg:first').hide().fadeIn().addClass('inserted');

            // Get sum height of all inserted bubbles
            $(".chatMsg.inserted").each(function(){
                loadedBubbleHeight = loadedBubbleHeight + $(this).outerHeight(true);
            });

            // Move to correct position, so that content is at same posotion after inserting.
            $(".chat-panel").scrollTop(loadedBubbleHeight - loading_spinner_height);

            // Resets
            $(".chatMsg.inserted").removeClass('inserted'); // remove class after calculation
            loadedBubbleHeight = 0; // reset bubbleheight
            loading_bubbles = false; // reset loading to default
          }, 2000);
        });
      }
      // Trigger Scroll to Bottom
      //if (elem[0].scrollHeight - elem.scrollTop() == elem.outerHeight() {
        //console.log("bottom rechaed");
      //}
    });


    $('select#compose-user-select').SumoSelect({
      search: true,
      searchText: 'Suche nach User.',
      placeholder: 'User auswählen',
      csvDispCount: 5
    });

    // Insert Fake Bubble
    $('.message-control .btn-primary').on('click', function(){
      $(".chat-message").animate({'height':'38px'}, 100, function() {
        var chatMessage = $('.chat-message').val();
        $('.chat-message').val('');
        var bContainer = $('<div class="chatMsg -right"><img class="attachment user avatar img-round" src="https://d1dcf21ighh4hq.cloudfront.net/attachments/fad5d1e8df9b7eba405c9f2deec155f27c709f09/store/fill/400/400/0a90d925fcde3d6fa5b1b3f35f7ba2753972a5c6164acc222ab2e172d1ae/avatar.png"><div class="bubble">'+chatMessage+'</div></div>');
        bContainer.insertAfter('.chat-panel .fake'+msg+' .chatMsg:last');
        scrollToLastMessage();
      });
    });

    // Fake Message Switch
    $('div[data-msg] .wrp').click(function() {
      $(".single-user").removeClass('-active');
      $(this).closest(".single-user").addClass('-active');
      msg = $(this).closest(".single-user").attr("data-msg");
      $(".message-wrapper").hide();
      $(".message-wrapper.fake"+msg).fadeIn();
      scrollToLastMessage();

      // If Mobile Show Chat Window
      if ($('body').hasClass('mob')) {
        $('#side-bar').toggleClass('is-collapsed');
        $('#main-content').toggleClass('is-full-width');
      }
    });

    $('.back-btn').click(function() {
      $('#side-bar').toggleClass('is-collapsed');
      $('#main-content').toggleClass('is-full-width');
    });

  }


  function setWindowHeight() {
    var vh = window.innerHeight * 0.01; // Needed for Exactly Mobile Height
    document.documentElement.style.setProperty('--vh', vh+'px');
  }


  function initJBox() {
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
  }


  return {
    init: init
  };

})();
