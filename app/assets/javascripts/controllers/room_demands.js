APP.controllers.room_demands = (function() {

  function init() {
    if ($("section.room-offer-form").exists()) initRoomForm();
    if ($("#GAinfos").exists()) initshowContact();
    if ($("#hide-contact-link").exists()) inithideContactLink();
  }

  function initshowContact(){

    var roomOwner_url = $('#roomContact_url').attr('data-id');
    var roomOwner_id = $('#roomContact_id').attr('data-id');
    var roomOwner_userid = $('#roomContact_id').attr('data-user');
    var roomContact_id = $('#roomContactClick_id').attr('data-id');

    var click_track = function() {
      // Analytics Tracking
      gtag(
        'event', 'RoomDemand Contact, id: ' + roomOwner_id, {
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
