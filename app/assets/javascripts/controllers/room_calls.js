APP.controllers.room_calls = (function() {

  function init() {
    if ($("section.room-call-form").exists()) {
      initRoomForm();
    }
    if ($(".room-call-page").exists()) {
      initMap();
    }
  }
  
  function initMap() {
    var mapdata = $('#graetzlMapWidget').data('mapdata');
    var map =  APP.components.graetzlMap;
    map.init(function() {
      map.showMapAddress(mapdata.addresses, mapdata.graetzls, {
        style: $.extend(map.styles.rose, { weight: 4, fillOpacity: 0.2 })
      });
    }, {interactive: true});
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
