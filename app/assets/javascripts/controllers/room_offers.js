APP.controllers.room_offers = (function() {

  function init() {
    if ($("section.room-offer-form").exists()) initRoomForm();
    if ($("#GAinfos").exists()) initshowContact();
    if ($("#hide-contact-link").exists()) inithideContactLink();
    if ($("section.roomDetail").exists()) { initRoomDetail(); }
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
        'event', 'RoomOffer Contact, id: ' + roomOwner_id, {
        'event_category': roomOwner_url,
        'event_label': 'clicked-user-id: ' + roomContact_id
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
    APP.components.addressSearchAutocomplete();

    $('#custom-keywords').tagsInput({
      'defaultText':'Kurz in Stichworten ..'
    });

    $('select#admin-user-select').SumoSelect({
      search: true,
      csvDispCount: 5
    });
  }

  return {
    init: init,
    initshowContact : initshowContact
  }

})();
