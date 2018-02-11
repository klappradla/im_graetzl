APP.controllers.room_offers = (function() {

    function init() {
        if ($("section.room-offer-form").exists()) initRoomForm();
        if ($("#GAinfos").exists()) initshowContact();

    }

    function initshowContact(){

          var roomContact_url = $('#roomContact_url').attr('data-id');
          var roomContact_id = $('#roomContact_id').attr('data-id');
          var roomContactClick_id = $('#roomContactClick_id').attr('data-id');

          $('#contact-infos-block').hide();
          $('#show-contact-link').on('click', function(event){
            event.preventDefault();
            $('#contact-infos-block').fadeIn();
            $(this).hide();
            gtag('event', 'RoomOffer Contact, id: ' + roomContact_id, {
              'event_category': roomContact_url,
              'event_label': 'clicked-user-id: ' + roomContactClick_id
            });
            //console.log('clicked-user-id: ', roomContactClick_id);
            //console.log('room-offer-id: ', roomContact_id);
            //console.log('room-offer-url: ', roomContact_url);
          });
          // Sidebar Button Click
          $('#room-contact-btn').on('click', function(event){
            gtag('event', 'RoomOffer Contact, id: ' + roomContact_id, {
              'event_category': roomContact_url,
              'event_label': 'clicked-user-id: ' + roomContactClick_id
            });
          });
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
