APP.controllers.discussions = (function() {

  function init() {
    APP.controllers.groups.init();
    initControls();
    if ($('.follow').exists()) { initFollowing(); }
  }

  function initControls() {
    $(".discussion-area").on('click', '.edit-post-link', function() {
      $(this).parents(".user-post").addClass("editing");
      $(".edit-post-form textarea").autogrow({ onInitialize: true });
    }).on('click', '.cancel-edit-link', function() {
      $(this).parents(".user-post").removeClass("editing");
    });

    $('.show-all-comments-link').on("click", function() {
      $(this).parents(".post-comments").find(".comment-container").show();
      $(this).hide();
    });

    // Get Target for Mandrill Linking
    $(window).on("load", function() {
      setTimeout(scrollToTarget, 250)
    });

  }

  function scrollToTarget() {
    var target = getUrlVars()["target"];
    if (typeof target !== 'undefined') {
      $('html, body').animate({
        scrollTop: $('#'+target).offset().top
      }, 600);
    }
  }

  function initFollowing() {
    $('.follow').on('click', function(){
      $('.follow').toggleClass('-hide');
      //console.log($(this).attr("data-topic"));
    })
  }

  function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
  }

  return {
    init: init
  };

})();
