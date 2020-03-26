APP.controllers.meetings = (function() {

    function init() {
      if ($("section.meeting").exists()) {
        initMeetingDetail();
      }

      if ($("section.create-meeting").exists()) {
        initCreateMeeting();
      }
    }

    function initMeetingDetail() {
      $('.entryDescription .bbcode').linkify({
        target: "_blank"
      });

      if ($(".additonal").exists()) {
        $('.dateTime').lightSlider({
          item: 2,
          autoWidth: false,
          slideMove: 2, // slidemove will be 1 if loop is true
          slideMargin: 0,
          addClass: 'additionalSlider',
          mode: "slide",
          useCSS: true,
          cssEasing: 'ease', //'cubic-bezier(0.25, 0, 0.25, 1)',//
          easing: 'linear', //'for jquery animation',////
          speed: 750, //ms'
          auto: false,
          loop: false,
          slideEndAnimation: true,
          pause: 10000,
          keyPress: false,
          controls: true,
          prevHtml: '',
          nextHtml: '',
          adaptiveHeight:false,
          pager: false,
          //currentPagerPosition: 'middle',
          enableTouch:true,
          enableDrag:false,
          freeMove:true,
          swipeThreshold: 40,
          responsive : [
            {
              breakpoint:APP.config.majorBreakpoints.large,
              settings: {
                item: 1,
                slideMove: 1
              }
            }
          ]
        });
      }

      var buyTicket = new jBox('Modal', {
        addClass:'jBox',
        attach: '#buyTicket',
        content: $('#jBoxBuyTicket'),
        trigger: 'click',
        closeOnEsc:true,
        closeOnClick:'body',
        blockScroll:true,
        animation:{open: 'zoomIn', close: 'zoomOut'},
        onOpen: function() {
          var meeting_id = $('#meeting_id').val();
          var page_title = 'Dein Ticket - Termin wählen - ' + document.title;
          var page_path = '/going_tos/choose_date?meeting_id='+meeting_id;
          gtag('config', window.imgraetzl.uaid, {
            'page_title': page_title,
            'page_path': page_path
          });
        }
      });

      var attendMeeting = new jBox('Modal', {
        addClass:'jBox',
        attach: '#attendMeeting',
        content: $('#jBoxAttendMeeting'),
        trigger: 'click',
        closeOnEsc:true,
        closeOnClick:'body',
        blockScroll:true,
        animation:{open: 'zoomIn', close: 'zoomOut'},
      });

      var meetingSettings = new jBox('Tooltip', {
        addClass:'jBox',
        attach: '#meetingSettings',
        content: $('#jBoxMeetingSettings'),
        trigger: 'click',
        closeOnClick:true,
        isolateScroll:true,
        animation:{open: 'zoomIn', close: 'zoomOut'},
      });

      // Goolge Map Script-Tag einbinden am Ende der Seite
      if ($("#google_map").exists()) {
        var google_api_key = $('#google_map').attr('data-google-api-key');
        var script_url = "https://maps.googleapis.com/maps/api/js?key="+google_api_key+"&callback=initMaps"
        var google_maps_script_tag = document.createElement('script');
        google_maps_script_tag.src = script_url;
        google_maps_script_tag.async = true;
        google_maps_script_tag.defer = true;
        document.body.appendChild(google_maps_script_tag);
      }

    }

    function initCreateMeeting() {
      APP.components.addressSearchAutocomplete();

      $('.create-meeting').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
        $('.datepicker').pickadate({
          formatSubmit: 'yyyy-mm-dd',
          hiddenName: true,
          min: true
        });

        $('.timepicker').pickatime({
          interval: 15,
          format: 'HH:i',
          formatSubmit: 'HH:i',
          hiddenSuffix: '',
        });
      });

      $(".meet-what textarea").autogrow({
        onInitialize: true
      });

      $('.datepicker').pickadate({
        formatSubmit: 'yyyy-mm-dd',
        hiddenName: true,
        min: true
      });

      $('.timepicker').pickatime({
        interval: 15,
        format: 'HH:i',
        formatSubmit: 'HH:i',
        hiddenSuffix: ''
      });

      // location field
      $('input:checkbox#location').on('change', function() {
        if (!this.checked) {
          $('#meeting_location_id').val('');
        }
        $('div#meeting-location-field').toggle();
      });

      // online meeting switch
      $('.online-meeting-switch').on('change', function() {
        if ( $(this).val() === "true") {
          $('#addressSearchAutocomplete').hide();
          $('#address-fields').hide();
          $('#online-address-fields').show();
        } else {
          $('#addressSearchAutocomplete').show();
          $('#address-fields').show();
          $('#online-address-fields').hide();
        }
      });

      // Hide Elements
      $('.hide').hide();

      $('select#admin-user-select').SumoSelect({
        search: true,
        searchText: 'Suche nach User.',
        placeholder: 'User auswählen',
      });

    }

    return {
      init: init
    };

})();
