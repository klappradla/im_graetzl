APP.controllers.discussions = (function() {

  function init() {
    APP.controllers.groups.init();
    if ($('.btn-control').exists()) {
      initControls();
    }
  }

  function initControls() {
    $('.user-post').mouseenter(function () {
      $(this).find('.btn-control').css('display','flex').hide().fadeIn('slow');
    }).mouseleave(function () {
      $(this).find('.btn-control').hide();
    });
  }

  return {
    init: init
  };

})();
