APP.controllers.groups = (function() {

    function init() {
      if ($(".group-form-page").exists()) {
        initGroupForm();
      }
      if ($(".group-page .categories-list").exists()) {
        initMobileNav();
      }
      if ($(".group-page").exists()) {
        initHeader();
        initInfo();
        initDiscussions();
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

    function initHeader() {
      APP.components.tabs.initTabs(".tabs-ctrl");

      $(".join-request-button").featherlight({
        root: '#groups-btn-ctrl',
        targetAttr: 'href'
      });

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

    function initInfo() {
      $(".all-discussions-link").on("click", function() {
        $(".tabs-ctrl").trigger('show', '#tab-discussions');
      });
    }

    function initDiscussions() {
      $('#tab-discussions .btn-new-topic').on('click', function() {
        $('#new-topic').slideToggle();
      });

      $("#tab-discussions .categories-list a").on("click", function() {
        $(this).parents("li").addClass("selected").siblings("li").removeClass("selected");
      });

      $("#tab-discussions .autoload-link").click();
    }

    function initMobileNav() {
      var $dropdown = $(".categories-list-mobile select");
      $(".categories-list li a").each(function() {
              var $this = $(this),
              link = $this.attr('href'),
              txt = $this.text();

          $dropdown.append(getOption());

          function getOption() {
              if($this.hasClass('autoload-link'))
                  return '<option selected value="'+ link +'" data-remote="true">'+ txt +'</option>';
              return '<option value="'+ link +'" data-remote="true">'+ txt +'</option>';
          }
      });
      $dropdown.on('change', function() {
        var getLink = $('.categories-list li a[href="'+$dropdown.val()+'"]');
        getLink.click();
      });
    }

    return {
      init: init
    };

})();
