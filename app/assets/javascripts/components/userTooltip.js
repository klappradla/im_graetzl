APP.components.initUserTooltip = function() {

  // jBox Tooltips for Users
  var user_tooltips = []

  // ------- DESKTOP Hover Tooltips -------
  $(".no-touch .signed-in .user-tooltip-trigger").each(function(index, value) {
      var tooltip = $(this).data('tooltip-id');
      user_tooltips[tooltip] = new jBox('Tooltip', {
        addClass:'jBox',
        attach: $(this),
        closeOnMouseleave: true,
        trigger:'mouseenter',
        delayOpen: 500,
        delayClose: 250,
        position: {
          x: 'center',
          y: 'bottom'
        },
        ajax: {
            reload: true,
            setContent: false,
            spinner:true,
            spinnerReposition:false,
            spinnerDelay:0,
            success: function (response) {
              this.setContent(response);
              initTrackingLinks();
              // Analytics
              gtag(
                'event', 'Open', {
                'event_category': 'User Tooltip',
                'event_label': 'Desktop'
              });
            }
        },
      });
  });

  // ------- MOBILE Click Modals -------
  $(".touch .signed-in .user-tooltip-trigger").each(function(index, value) {
      var tooltip = $(this).data('tooltip-id');
      user_tooltips[tooltip] = new jBox('Modal', {
        addClass:'jBox',
        attach: $(this),
        trigger:'click',
        preventDefault:true,
        closeButton:true,
        ajax: {
            reload: true,
            setContent: false,
            spinner:true,
            spinnerReposition:false,
            spinnerDelay:0,
            success: function (response) {
              this.setContent(response);
              initTrackingLinks();
              // Analytics
              gtag(
                'event', 'Open', {
                'event_category': 'User Tooltip',
                'event_label': 'Mobile'
              });
            }
        },
      });
  });


  // Init Click Links to be ready after Tooltip is open
  function initTrackingLinks() {
    // Link - Messenger
    $('.user-tooltip-wrp .-messenger a').on('click', function(event){
      event.preventDefault();
      var href = $(this).attr('href');
      gtag(
        'event', 'Click :: Nachricht senden', {
        'event_category': 'User Tooltip',
        'event_callback': function() {
          location.href = href;
        }
      });
    });
    // Link - Profile
    $('.user-tooltip-wrp .tt-img a, .user-tooltip-wrp a.username').on('click', function(event){
      event.preventDefault();
      var href = $(this).attr('href');
      gtag(
        'event', 'Click :: Profil anzeigen', {
        'event_category': 'User Tooltip',
        'event_callback': function() {
          location.href = href;
        }
      });
    });
  }

};

APP.components.initUserTooltip();
