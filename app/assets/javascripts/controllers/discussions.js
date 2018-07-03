APP.controllers.discussions = (function() {

  function init() {
    APP.controllers.groups.init();
    initControls();
    if ($('.follow').exists()) { initFollowing(); }
  }

  function initControls() {
    $(".discussion-page").on('click', '.edit-post-link', function() {
      $(this).parents(".user-post").addClass("editing");
    }).on('click', '.cancel-edit-link', function() {
      $(this).parents(".user-post").removeClass("editing");
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
