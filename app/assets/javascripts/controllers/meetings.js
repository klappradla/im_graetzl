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
      $('.entryDescription .txt').linkify({
        target: "_blank"
      });
    }

    function initCreateMeeting() {
      APP.components.addressSearchAutocomplete();

      $(".meet-what textarea").autogrow({
        onInitialize: true
      });

      $('.datepicker').pickadate({
        formatSubmit: 'yyyy-mm-dd',
        hiddenName: true
      });

      $('.timepicker').pickatime({
        interval: 15,
        format: 'HH:i',
        formatSubmit: 'HH:i',
        hiddenSuffix: ''
      });

      $('select.categories').SumoSelect({
        placeholder: 'Ordne dein Treffen einen oder mehreren Themen zu',
        csvDispCount: 5,
        captionFormat: '{0} Kategorien ausgewählt'
      });

      // location field
      $('input:checkbox#location').on('change', function() {
        if (!this.checked) {
          $('#meeting_location_id').val('');
        }
        $('div#meeting-location-field').toggle();
      });

    }

    return {
      init: init
    };

})();
