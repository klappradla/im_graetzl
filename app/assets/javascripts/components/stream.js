APP.components.stream = (function() {

    function init() {
        initEntryCreateForm();
        initCommentForm();
        initImgGallery();
        initLinkify();

        $('.show-all-comments-link').on("click", function() {
          $(this).parents(".post-comments").find(".comment-container").show();
          $(this).hide();
        });

    }

    function initEntryCreateForm() {

        var $parent = $('.entryCreate').not('.js-initialized');

        if($parent.find('.postTitle').exists()) {
            $parent.find('.postMessage').autogrow();
            $parent.addClass('js-initialized')
                .find('.postTitle, .postMessage')
                .on("focusin", function() {
                    $parent.addClass("is-focused");
                })
                .on("focusout", function() {
                    if(!$('.postTitle').val().length && !$('.postMessage').val().length ) {
                        $parent.removeClass("is-focused");
                    }
                });
        } else {
            initSingleTextarea($parent);
        }
    }

    function initLinkify() {
        $('.stream .entryInitialContent .txt').linkify({ target: "_blank"});
        $('.stream .post-comments .txt').linkify({ target: "_blank"});
    }

    function initCommentForm() {
        $('.entryCommentForm').not('.js-initialized').each(function() {
            var $parent = $(this);
            initSingleTextarea($parent);
        })
    }

    function initImgGallery() {
        $('.entryCreate').not('.js-initialized').featherlightGallery({
            openSpeed: 300
        }).addClass('js-initialized');
    }

    function initSingleTextarea($parent) {
        $parent
            .addClass('js-initialized')
            .find('textarea')
            .autogrow()
            .on("focusin touch", function(){
                (APP.utils.isLoggedIn()) ? $parent.addClass("is-focused") : injectFormBlocker($parent);
            });
    }

    function injectFormBlocker($container) {
        $('.stream .formBlocker').remove();

        var $markup = $('<div class="formBlocker">' +
            '<div class="wrp">' +
            '<div>Du musst eingeloggt sein, um einen Kommentar zu verfassen.</div>' +
            '<div><a href="/users/login">Zum Login</a> | <a href="/users/registrierung">Zur Registrierung</a></div>' +
            '<span class="close"></span>' +
            '</div>' +
            '</div>');

        $container.find('textarea').prop('disabled', true);
        $container.find('textarea').blur();
        $container.append($markup);
        $markup.hide().fadeIn();
        $markup.on('click', function(e) { e.stopPropagation(); });
        $(document).add($container.find('.close')).on('click.hideblock', function(e) {
            $markup.remove();
            $container.find('textarea').prop('disabled', false);
            $(document).off('click.hideblock');
        });
    }

    return {
        init : init,
        initEntryCreateForm : initEntryCreateForm,
        initCommentForm : initCommentForm,
        initImgGallery : initImgGallery,
        initLinkify: initLinkify
    }

})();
