APP.controllers.meetings = (function() {

    function init() {
      if ($("section.meeting").exists()) {
        initMeetingDetail();
      }

      if ($("section.create-meeting").exists()) {
        initCreateMeeting();
      }

      if ($("section.meetings-compose-mail").exists()) {
        initComposeMailMeeting();
      }

    }

    function initComposeMailMeeting() {

      $('select#mail-user-select').SumoSelect({
        search: true,
        searchText: 'Suche nach User.',
        placeholder: 'User auswählen',
        csvDispCount: 2,
        captionFormat: '{0} Treffenmitglieder',
        captionFormatAllSelected: 'Alle Treffenmitglieder',
        //okCancelInMulti: true,
        selectAll: true,
        //triggerChangeCombined: false,
        isClickAwayOk: true,
        locale: ['OK', 'Abbrechen', 'Alle auswählen']
      });

      // Highlight Users on single Click Options
      $('.select_users .opt').on('click', function(){
        var user_index = $(this).index();
        if ($(this).hasClass('selected')){
          $('.meetings-compose-mail .members a').eq(user_index).find('.avatar').addClass('active');
        } else {
          $('.meetings-compose-mail .members a').eq(user_index).find('.avatar').removeClass('active');
        }
      });

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

      var meetingSettingsPaid = new jBox('Tooltip', {
        addClass:'jBox',
        attach: '#meetingSettingsPaid',
        content: $('#jBoxMeetingSettingsPaid'),
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

      // Analytics
      $('.meeting-attend-btn').on('click', function() {
        gtag(
          'event', 'Click :: Interessiert', {
          'event_category': 'Meeting'
        });
      });

      $('.meeting-unattend-btn').on('click', function() {
        gtag(
          'event', 'Click :: Nicht mehr Interessiert', {
          'event_category': 'Meeting'
        });
      });


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

      $("textarea").autogrow({
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

      // location field toggle
      $('input:checkbox#location').on('change', function() {
        if (!this.checked) {
          $('#meeting_location_id').val('');
        }
        $('div#meeting-location-field').slideToggle();
      });


      // platform_meeting toggle
      var $platform_join_checkbox = $('input:checkbox#meeting_platform_meeting_join_request_attributes_status');
      if(!document.getElementById('meeting_platform_meeting_join_request_attributes_status').checked) {
        $('div#meeting-platform-meeting-fields').hide();
      }
      $platform_join_checkbox.on('change', function() {
        $('div#meeting-platform-meeting-fields').slideToggle();
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

      $(".event-categories input").on("change", function() {
        maxCategories(); // init on Change
      });

      maxCategories(); // init on Load

    }

    function maxCategories() {
      if ($(".event-categories input:checked").length >= 3) {
        $(".event-categories input:not(:checked)").each(function() {
          $(this).prop("disabled", true);
          $(this).parents(".input-checkbox").addClass("disabled");
        });
      } else {
        $(".event-categories input").prop("disabled", false);
        $(".event-categories .input-checkbox").removeClass("disabled");
      }
    }

    return {
      init: init
    };

})();
