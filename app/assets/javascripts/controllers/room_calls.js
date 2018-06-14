APP.controllers.room_calls = (function() {

  function init() {
    if ($("section.room-call-form").exists()) {
      initRoomForm();
    }
  }

  function initRoomForm() {
    APP.components.addressSearchAutocomplete();

    $('.datepicker').pickadate({
      formatSubmit: 'yyyy-mm-dd',
      hiddenName: true
    });

    $('select#admin-user-select').SumoSelect({
      search: true,
      csvDispCount: 5
    });
  }

  return {
    init: init,
  }

})();
