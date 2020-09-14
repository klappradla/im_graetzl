APP.controllers.room_offers = (function() {

  function init() {
    if ($("section.room-offer-form").exists()) initRoomForm();
    if ($("#GAinfos").exists()) initshowContact();
    if ($("#hide-contact-link").exists()) inithideContactLink();
    if ($("section.roomDetail").exists()) { initRoomDetail(); }
    if ($(".request-price-form").exists()) initRoomOfferBookingForm();
    if ($(".room-rental-timetable-page").exists()) initTimeTable();
  }

  function initTimeTable() {

  }


  function initRoomOfferBookingForm() {
    var dateInput = $('.request-price-form .rent-date');
    var days = dateInput.data("days");
    var disabledDays = [true].concat(days);

    $('.request-price-form .rent-date').pickadate({
      hiddenName: true,
      min: true,
      formatSubmit: 'yyyy-mm-dd',
      format: 'ddd, dd mmm, yyyy',
      disable: disabledDays,
      onClose: function() {
        $(document.activeElement).blur();
      },
      // Insert Legend (improve ...)
      onRender: function() {
        $(".request-price-form .picker__box").append( "<div class='picker__legend'><div class='legend_not_availiable'></div><small class='legend_text'> ... an diesen Tagen nicht verfügbar</small></div>" );
        $(".request-price-form .picker__box .picker__header").append( "<div class='picker__header_info'><small class='legend_headline'>Wann möchtest du anmieten?</small><small class='legend_text'>(Du kannst im nächsten Schritt auch noch weitere Tage hinzufügen)</small></div>" );
      }
    });

    $('.request-price-form .rent-date').on("change", function() {
      $('.request-price-form .hour-input').attr("disabled", !$(this).val());
    });

    $('.request-price-form').find(".rent-date, .hour-from").on("change", function() {
      var form = $(this).parents(".request-price-form");
      var hoursUrl = form.data('hours-url');
      var currentDate = form.find(".rent-date").pickadate('picker').get('select', 'yyyy-mm-dd');
      var hourFrom = form.find(".hour-from").val();

      $.get(hoursUrl, {rent_date: currentDate, hour_from: hourFrom}, function(data) {
        form.find(".hour-from option").not(':empty').each(function(i, o) {
          var hour = +$(o).val();
          $(o).attr("disabled", data.from.indexOf(hour) == -1);
        });
        form.find(".hour-to option").not(':empty').each(function(i, o) {
          var hour = +$(o).val();
          $(o).attr("disabled", data.to.indexOf(hour) == -1);
        });
      });
    });

    $('.request-price-form').on("change", '.hour-input', function() {
      if ($('.hour-from').val() > 0 && $('.hour-to').val() > 0) {
        $(this).parents(".request-price-form").submit();
        // Analytics Tracking
        gtag(
          'event', 'Raumangebot :: Kurzzeitmiete Buchungsbox', {
          'event_category': 'Raumteiler',
          'event_label': 'Auswahl :: Zeitraum'
        });
      }
    });

    $(".request-price-form").on("ajax:complete", function() {
      new jBox('Tooltip', {
        attach: '.tooltip-trigger',
        trigger: 'click',
        closeOnClick: true,
        closeOnMouseleave: true,
      });
    });

  }

  function initRoomDetail() {

    var roomGallery = new jBox('Image', {
      addClass:'jBoxGallery',
      imageCounter:true,
      preloadFirstImage:true,
      closeOnEsc:true,
      createOnInit:true,
      animation:{open: 'zoomIn', close: 'zoomOut'},
    });

    // Sidebar Button Click
    $('#requestRoomBtn').on('click', function(event){
      event.preventDefault();
      var href = $(this).attr('href');
      gtag(
        'event', 'Raumangebot :: Click :: Allgemeine Anfrage stellen', {
        'event_category': 'Raumteiler',
        'event_callback': function() {
          location.href = href;
        }
      });
    });

  }

  function initshowContact(){

    var roomOwner_url = $('#roomContact_url').attr('data-id');
    var roomOwner_id = $('#roomContact_id').attr('data-id');
    var roomOwner_userid = $('#roomContact_id').attr('data-user');
    var roomContact_id = $('#roomContactClick_id').attr('data-id');

    var click_track = function() {
      // Analytics Tracking
      gtag(
        'event', 'Raumangebot :: Click :: Kontaktinformationen einblenden', {
        'event_category': 'Raumteiler',
        'event_label': 'User: ' + roomContact_id
      });

      // Mailchimp Tracking
      $.ajax({
        url : '/clicked-room',
        type : 'post',
        data : { user_id: roomOwner_userid },
        dataType: 'json',
        success: function(response) {
          //console.log(response);
        }
      });
    }

    $('#contact-infos-block').hide();
    $('#show-contact-link').on('click', function(event){
      event.preventDefault();
      $('#contact-infos-block').fadeIn();
      $(this).hide();
      click_track();
    });

  }

  function inithideContactLink(){
    $('#contact-infos-block').show();
    $('#show-contact-link').hide();
  }


  function initRoomForm() {
    APP.components.tabs.initTabs(".tabs-ctrl");
    APP.components.addressSearchAutocomplete();

    $(".next-screen, .prev-screen").on("click", function() {
      $('.tabs-ctrl').trigger('show', '#' + $(this).data("tab"));
      $('.tabs-ctrl').get(0).scrollIntoView();
    });

    $('#custom-keywords').tagsInput({
      'defaultText':'Kurz in Stichworten ..'
    });

    $(".availability-select").on("change", function() {
      var day = $(this).data("weekday");
      if ($(this).val() == "0") {
        $(".availability-input-" + day).prop("disabled", true);
      } else {
        $(".availability-input-" + day).removeProp("disabled");
      }
    }).change();

    var formSections = null;
    $(".price-per-hour-input").on("change", function() {
      if ($(this).val() && formSections) {
        $('.rental-availability-container').replaceWith(formSections['availability']);
        $('.user-billing-container').replaceWith(formSections['userBilling']);
        formSections = null;
      } else if (!$(this).val() && !formSections) {
        formSections = {
          'availability': $('.rental-availability-container').clone(),
          'userBilling': $('.user-billing-container').clone(),
        };
        $('.rental-availability-container, .user-billing-container').empty();
      }
    });

    $('select#admin-user-select').SumoSelect({
      search: true,
      csvDispCount: 5
    });

    // Slot Fields Toogle
    $('.slot-radios .rental-toggle-input').on('change', function() {
      if ($('.slot-radios .rental-toggle-input:checked').val() == 'true') {
        $('#slot-fields').slideDown();
      } else {
        $('#slot-fields').hide();
      }
    }).change();


    $(".room-categories input").on("change", function() {
      maxCategories(); // init on Change
    });

    maxCategories(); // init on Load

  }

  function maxCategories() {
    if ($(".room-categories input:checked").length >= 5) {
      $(".room-categories input:not(:checked)").each(function() {
        $(this).prop("disabled", true);
        $(this).parents(".input-checkbox").addClass("disabled");
      });
    } else {
      $(".room-categories input").prop("disabled", false);
      $(".room-categories .input-checkbox").removeClass("disabled");
    }
  }

  return {
    init: init,
    initshowContact : initshowContact
  }

})();
