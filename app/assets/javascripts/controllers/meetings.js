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

      // preselect group from param-id
      var group_id = $('#group_id').val();
      var exists = 0 != $('#meeting_group_id option[value='+group_id+']').length;
      if (exists == true) {
        $('#meeting_group_id').val(group_id).change();
      }
    }

    return {
      init: init
    };

})();
