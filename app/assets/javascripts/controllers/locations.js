APP.controllers.locations = (function() {

    function init() {
        if($("section.selectGraetzl").exists()) initSelectGraetzl();
        if($("section.location-form").exists()) initLocationForm();
        if($("section.location-page").exists()) initLocationPage();
    }


    function initSelectGraetzl() {
      APP.components.graetzlSelect();
    }

    function initLocationForm() {
        $("#location_description, #location_contact_attributes_hours").autogrow({
            onInitialize: true
        });

        $('form').on('click', '.add_address_fields', function(event) {
            var fields = $(this).data('fields');
            $(this).replaceWith(fields);
            event.preventDefault();
        });

        $('form').on('click', '.remove_address_fields', function(event) {
            $(this).prev('input[type=hidden]').val('1');
            $(this).closest('div.form-block').hide();
            event.preventDefault();
        });

        $('#location_product_list').tagsInput({
            'defaultText':'Tags'
        });

        // TODO: change name of wrapper class
        $('section.location-form').on('click', '.add_graetzl_fields', function(event) {
            var fields = $(this).data('fields');
            $('input#location_graetzl_id').replaceWith(fields);
            $(this).hide();
            APP.components.graetzlSelect();
            event.preventDefault();
        });
    }

    function initLocationPage() {
        $('.introtxt .txt').linkify({ target: "_blank"});
        $('[data-behavior=createTrigger]').jqDropdown('attach', '[data-behavior=createContainer]');

        $('.autosubmit-stream').submit();

        $('.show-all-comments-link').on("click", function() {
          $(this).parents(".post-comments").find(".comment-container").removeClass("hide");
          $(this).hide();
        });

        // open comments if post hash exists
        var hash = window.location.hash.substr(1);
        if (hash.indexOf("location_post") != -1) {
          $( "#" + hash + " .show-all-comments-link" ).click();
        }

        enquire
            //mobile mode
            .register("screen and (max-width:" + APP.config.majorBreakpoints.large + "px)", {
                match : function() {
                    $('.stream').insertAfter('.sideBar');
                }
            })
            //desktop mode
            .register("screen and (min-width:" + APP.config.majorBreakpoints.large + "px)", {
                match : function() {
                    $('.stream').appendTo('.mainContent');
                }
            });
    }

    return {
      init: init
    };

})();
