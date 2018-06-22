APP.controllers.discussions = (function() {

  function init() {
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

    $('.btn-control a').hover(function (){
      $(this).addClass('active');
    }, function(){
      $(this).removeClass('active');
    });
  }

  return {
    init: init
  };

})();
