APP.components.initUserTooltip = function() {

  // jBox Tooltips for Users
  var user_tooltips = []

  // Desktop Hover Tooltips
  // selector eingrenzen auf .signed-in wenn nur eingeloggt

  if ($('html').hasClass('no-touch')) {
      var trigger = "mouseenter";
      var preventDefault = false;
      var delayOpen = 500;
      var delayClose = 250;
  } else {
      var trigger = "touchclick";
      var preventDefault = true;
      var delayOpen = 0;
      var delayClose = 0;
  }

  $(".signed-in .user-tooltip-trigger").each(function(index, value) {

      var tooltip = $(this).data('tooltip-id');
      user_tooltips[tooltip] = new jBox('Tooltip', {
        addClass:'jBox',
        attach: $(this),
        closeOnMouseleave: true,
        trigger:trigger,
        preventDefault:preventDefault,
        delayOpen: delayOpen,
        delayClose: delayClose,
        closeOnClick:'body',
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
                //'event_label': 'User: ' + roomContact_id
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
