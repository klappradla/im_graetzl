APP.controllers.room_demands = (function() {

  function init() {
    if ($("section.room-offer-form").exists()) initRoomForm();
    if ($("#GAinfos").exists()) initshowContact();
    if ($("#hide-contact-link").exists()) inithideContactLink();
    if ($("section.roomDetail").exists()) { initRoomDetail(); }
  }

  function initRoomDetail() {
    // Sidebar Button Click
    $('#requestRoomBtn').on('click', function(event){
      event.preventDefault();
      var href = $(this).attr('href');
      gtag(
        'event', 'Raumsuche :: Click :: Kontaktieren', {
        'event_category': 'Raumteiler',
        'event_callback': function() {
          location.href = href;
        }
      });
    });

    // Reactivate Raumteiler
    if ( $("#flash .notice").text().indexOf('Dein Raumteiler wurde erfolgreich verlängert!') >= 0 ){
      gtag(
        'event', 'Raumsuche :: Click :: E-Mail Aktivierungslink', {
        'event_category': 'Raumteiler'
      });
    }

    // Activate Raumteiler
    if ( $("#flash .notice").text().indexOf('Deine Raumsuche ist nun aktiv') >= 0 ){
      gtag(
        'event', 'Raumsuche :: Click :: Status Aktiv', {
        'event_category': 'Raumteiler'
      });
    }

    // Deactivate Raumteiler
    if ( $("#flash .notice").text().indexOf('Dein Raumsuche ist nun deaktiviert') >= 0 ){
      gtag(
        'event', 'Raumsuche :: Click :: Status Inaktiv', {
        'event_category': 'Raumteiler'
      });
    }

  }

  function initshowContact(){

    var roomOwner_url = $('#roomContact_url').attr('data-id');
    var roomOwner_id = $('#roomContact_id').attr('data-id');
    var roomOwner_userid = $('#roomContact_id').attr('data-user');
    var roomContact_id = $('#roomContactClick_id').attr('data-id');

    var click_track = function() {
        // Analytics Tracking
        gtag(
          'event', 'Raumsuche :: Click :: Kontaktinformationen einblenden', {
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
      APP.components.graetzlSelectFilter.init($('#district-graetzl-select'));

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
