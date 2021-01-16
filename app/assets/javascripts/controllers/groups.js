APP.controllers.groups = (function() {

    function init() {
      if ($(".group-page").exists()) { initGroupPage(); }
      if ($(".group-form-page").exists()) { initGroupForm(); }
    }

    function initGroupPage() {

      $('.autosubmit-stream').submit(); // Used for Meetings Tabs - Make like Discussions

      APP.components.tabs.initTabs(".tabs-ctrl");

      var target = APP.controllers.application.getUrlVars()["category"];
      if (typeof target !== 'undefined') {
        $('.tabs-ctrl').trigger('show', '#tab-discussions');
      }

      // Load on Pageload if Tab is selected
      if($("#tab-discussions").is(":visible")){
        initDiscussions();
      }

      // Load on Tab Change
      $('.tabs-ctrl').on("_after", function() {
          if($("#tab-discussions").is(":visible")){
            initDiscussions();
          }
      });

      var mobCreate = new jBox('Modal', {
        addClass:'jBox',
        attach: '.mob #createTopic',
        content: $('#jBoxCreateTopic'),
        trigger: 'click',
        closeOnClick:true,
        blockScroll:true,
        animation:{open: 'zoomIn', close: 'zoomOut'},
      });

      var deskCreate = new jBox('Tooltip', {
        addClass:'jBox',
        attach: '.desk #createTopic',
        content: $('#jBoxCreateTopic'),
        trigger: 'click',
        closeOnClick:true,
        pointer:'right',
        adjustTracker:true,
        isolateScroll:true,
        adjustDistance: {top: 25, right: 25, bottom: 25, left: 25},
        animation:{open: 'zoomIn', close: 'zoomOut'},
        maxHeight:500,
      });

      var joinRequest = new jBox('Modal', {
        addClass:'jBox',
        attach: '#joinRequest',
        content: $('#jBoxRoinRequest'),
        trigger: 'click',
        blockScroll:true,
        animation:{open: 'zoomIn', close: 'zoomOut'},
      });

      /*
      var newTopic = new jBox('Confirm', {
        addClass:'jBox',
        attach: '.newTopicTrigger',
        content: $('#newTopic'),
        trigger: 'click',
        closeOnEsc:true,
        closeOnClick:'body',
        closeOnConfirm:false,
        blockScroll:true,
        animation:{open: 'zoomIn', close: 'zoomOut'},
        confirmButton: 'Thema erstellen',
        cancelButton: 'Abbrechen',
        minWidth: 900,
        confirm: function() {
          $('.jBox-Confirm .discussion-form').find('.btn-primary').trigger('click');
        }
      });

      $('#tab-discussions .btn-new-topic').on('click', function() {
        $('#new-topic').slideToggle();
      });
      */

      $(".request-message-opener").featherlight({
        root: '#groups-btn-ctrl',
        targetAttr: 'href'
      });

      $('select#mail-user-select').SumoSelect({
        search: true,
        searchText: 'Suche nach User.',
        placeholder: 'User auswählen',
        csvDispCount: 2,
        captionFormat: '{0} Gruppenmitglieder',
        captionFormatAllSelected: 'Alle Gruppenmitglieder',
        okCancelInMulti: true,
        selectAll: true,
        locale: ['OK', 'Cancel', 'Alle auswählen']
      });

    }


    function selectDiscussion(category) {

      $('input:radio.filter-radio-category').each(function () {
        $(this).prop('checked', false);
      });

      if (typeof category !== "undefined") {
        $('input:radio.filter-radio-category[value='+category+']').prop("checked",true);
      }
      else {
        $('input:radio.filter-radio-category.-all').prop("checked",true);
      }

      APP.components.cardFilter.updateFilterLabels($('#filter-modal-category'));
      APP.components.cardFilter.submitForm();
      APP.components.cardFilter.gtag_tracking($('#filter-modal-category'));

    }


    function initDiscussions() {
      if ($('*[data-behavior="discussions-card-container"]').is(':empty')){
        APP.components.cardFilter.init();
      } else {
        APP.components.cardFilter.submitForm();
      }
    }


    function initGroupForm() {
      $(".group-categories input").on("change", function() {
        if ($(".group-categories input:checked").length >= 3) {
          $(".group-categories input:not(:checked)").each(function() {
            $(this).prop("disabled", true);
            $(this).parents(".input-checkbox").addClass("disabled");
          });
        } else {
          $(".group-categories input").prop("disabled", false);
          $(".group-categories .input-checkbox").removeClass("disabled");
        }
      });
      APP.components.graetzlSelectFilter.init($('#district-graetzl-select'));
    }


    return {
      init: init,
      selectDiscussion: selectDiscussion
    };


})();
