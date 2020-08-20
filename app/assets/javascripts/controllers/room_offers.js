APP.controllers.room_offers = (function() {

  function init() {
    if ($("section.room-offer-form").exists()) initRoomForm();
    if ($("#GAinfos").exists()) initshowContact();
    if ($("#hide-contact-link").exists()) inithideContactLink();
    if ($("section.roomDetail").exists()) { initRoomDetail(); }
    if ($(".request-price-form").exists()) initRoomOfferBookingForm();
  }

  function initRoomOfferBookingForm() {
    var dateInput = $('.request-price-form').find(".rent-date");
    var days = dateInput.data("days");
    var disabledDays = [true].concat(days);

    $('.request-price-form').find(".rent-date").pickadate({
      hiddenName: true,
      min: true,
      formatSubmit: 'yyyy-mm-dd',
      format: 'ddd, dd mmm, yyyy',
      //disable: days.map(function(v, i) { return v ? null : i; }),
      disable: disabledDays,
      onClose: function() {
        $(document.activeElement).blur();
      },
      // Insert Legend (improve ...)
      onRender: function() {
        $(".request-price-form .picker__box").append( "<div class='picker__legend'><div class='legend_not_availiable'></div><small class='legend_availiable_text'> ... Nicht verfügbar</small><div class='legend_availiable'></div><small class='legend_availiable_text'> ... Verfügbar</small></div>" );
      }
    }).on("change", function() {
      $(this).parents(".request-price-form").submit();
    });

    $('.request-price-form').on("change", '.hour-input', function() {
      $(this).parents(".request-price-form").submit();
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

  }

  function initshowContact(){

    var roomOwner_url = $('#roomContact_url').attr('data-id');
    var roomOwner_id = $('#roomContact_id').attr('data-id');
    var roomOwner_userid = $('#roomContact_id').attr('data-user');
    var roomContact_id = $('#roomContactClick_id').attr('data-id');

    var click_track = function() {
      // Analytics Tracking
      gtag(
        'event', 'Contact Click RoomOffer: ' + roomOwner_id, {
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

    // Sidebar Button Click
    $('#room-contact-btn').on('click', function(event){
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

    $(".next-screen").on("click", function() {
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

    $('select#admin-user-select').SumoSelect({
      search: true,
      csvDispCount: 5
    });

    $(".room-categories input").on("change", function() {
      maxCategories(); // init on Change
    });

    maxCategories(); // init on Load

  }

  function maxCategories() {
    if ($(".room-categories input:checked").length >= 3) {
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
