APP.controllers.discussions = (function() {

  function init() {
    APP.controllers.groups.init();
    initControls();
    if ($('.follow').exists()) { initFollowing(); }
  }

  function initControls() {
    $(".discussion-page").on('click', '.edit-post-link', function() {
      $(this).parents(".user-post").addClass("editing");
      $(".edit-post-form textarea").autogrow({ onInitialize: true });
    }).on('click', '.cancel-edit-link', function() {
      $(this).parents(".user-post").removeClass("editing");
    });

    $('.show-all-comments-link').on("click", function() {
      $(this).parents(".post-comments").find(".comment-container").show();
      $(this).hide();
    });

  }

  function initFollowing() {
    $('.follow').on('click', function(){
      $('.follow').toggleClass('-hide');
      //console.log($(this).attr("data-topic"));
    })
  }

  return {
    init: init
  };

})();
