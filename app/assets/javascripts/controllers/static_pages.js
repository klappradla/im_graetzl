APP.controllers.static_pages = (function() {

    function init() {
      if($("#help_nav").exists()) initHelpScroller();
      if($("section.help").exists()) initMobileNav();
      if($("section.homeOut").exists()) initMobileNav();
      if($(".-mentoring-page").exists()) initMentoring();
      if($("section.-raumteilerguide").exists()) initGuideLP();
      if($("#guide-download").exists()) initGuideDownload();
    }

// ---------------------------------------------------------------------- Public

function initMentoring() {
  $(".-login").featherlight({});

  // Change Wording of Notice Message for Mentoring Registrations
  if ($("#flash .notice").exists()) {
    if ( $("#flash .notice").text().indexOf('Vielen Dank für Deine Registrierung.') >= 0 ){
      // Modifiy Message for Mentoring
      $("#flash .notice").html('Vielen Dank für Deine Registrierung. Du bist nun angemeldet und kannst das <a href="#teilnahme">Teilnahme Formular</a> (unterhalb) ausfüllen.');
    }
  }
}

function initGuideDownload() {

  $('#guide-download').on('click', function(){
    gtag('event', 'Download', {
      'event_category': 'Raumteiler-Guide'
    });
  });

}

function initGuideLP() {

  $(document).ready( function () {
    var $form = $('#mc-embedded-subscribe-form');

    // E-Mail Check
    String.prototype.isEmail = function () {
      var validmailregex = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.([a-z][a-z]+)|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
      return validmailregex.test(this);
    }

    $('#mc-embedded-subscribe').on('click', function( event ){
      event.preventDefault();

      var fname = $('#mce-FNAME').val();
      var email = $('#mce-EMAIL').val();

      if(fname == '' || email == '') {

        $('#mce-error-response').fadeIn().html('Bitte gib deinen Vornamen und eine gültige E-Mail Adresse an.');

      } else if (!email.isEmail()) {

        $('#mce-error-response').fadeIn().html('Bitte gib eine gültige E-Mail Adresse an.');

      }

      else {
        $('#mce-error-response').fadeOut();
        subscribeMC($form);
      }
    })
  });

  var subscribeMC = function($form) {
    $.ajax({
        type: $form.attr('method'),
        url: $form.attr('action'),
        data: $form.serialize(),
        cache       : false,
        dataType    : 'json',
        contentType: "application/json; charset=utf-8",
        error       : function(err) { alert("Could not connect to the registration server. Please try again later."); },
        success     : function(data) {
            if (data.result != "success") {

              $('#mce-error-response').fadeIn().html(data.msg);
              console.log(data);

            } else {
              $('#mce-error-response').fadeOut();
              $('.input-field').fadeOut();
              $('#mc-embedded-subscribe').fadeOut();
              $('#mce-success-response').fadeIn().html('<strong>Dein Guide ist unterwegs!</strong><br>Wir haben dir soeben eine E-Mail geschickt.<br>Bitte klicke auf den Bestätigungslink um zum Download zu gelangen..');
            }
        }
    });
  }

}



function initMobileNav() {
  var $dropdown = $(".filter-stream .input-select select");
  $(".filter-stream .iconfilter").not('.createentry, .loginlink').each(function() {
      var $this = $(this),
          link = $this.prop('href'),
          txt = $this.find('.txt').text();

      $dropdown.append(getOption());
      $dropdown.on('change', function() {
          document.location.href = $dropdown.val();
      });

      function getOption() {
          if($this.hasClass('active'))
              return '<option selected value="'+ link +'">'+ txt +'</option>';
          return '<option value="'+ link +'">'+ txt +'</option>';
      }

  });
  $('[data-behavior=createTrigger]').jqDropdown('attach', '[data-behavior=createContainer]');
}

// Dont scroll over the Footer Element
function checkOffset() {
    if($('#help_nav').offset().top + $('#help_nav').height() >= $('#footer').offset().top )
      $('#help_nav').addClass( "fix_nav" ).removeClass( "float_nav" );
}

function initHelpScroller() {

  var elementPosition = $('#help_nav').offset();

  $(window).scroll(function(){
          if($(window).scrollTop() > elementPosition.top){
              $('#help_nav').addClass( "float_nav" ).removeClass( "fix_nav" );
              checkOffset();
          } else {
              $('#help_nav').css('position','static').removeClass( "fix_nav" ).removeClass( "float_nav" );
          }
  });

  var $sections = $('.container');

  // The user scrolls
  $(window).scroll(function(){

    // currentScroll is the number of pixels the window has been scrolled
    var currentScroll = $(this).scrollTop();

    // $currentSection is somewhere to place the section we must be looking at
    var $currentSection

    // We check the position of each of the divs compared to the windows scroll positon
    $sections.each(function(){
      // divPosition is the position down the page in px of the current section we are testing
      var divPosition = $(this).offset().top;
      // If the divPosition is less the the currentScroll position the div we are testing has moved above the window edge.
      // the -1 is so that it includes the div 1px before the div leave the top of the window.
      if( divPosition - 1 < currentScroll ){
        // We have either read the section or are currently reading the section so we'll call it our current section
        $currentSection = $(this);
        // If the next div has also been read or we are currently reading it we will overwrite this value again. This will leave us with the LAST div that passed.

        // This is the bit of code that uses the currentSection as its source of ID

        var id = $currentSection.attr('id');
        $('a').addClass('-mint');
        $('#nav-'+id).removeClass('-mint');
      }
    })
  });


  $('a[href*="#"]')
    // Remove links that don't actually link to anything
    .not('[href="#"]')
    .not('[href="#0"]')
    .click(function(event) {
      // On-page links
      if (
        location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
        &&
        location.hostname == this.hostname
      ) {
        // Figure out element to scroll to
        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
        // Does a scroll target exist?
        if (target.length) {
          // Only prevent default if animation is actually gonna happen
          event.preventDefault();
          $('html, body').animate({
            scrollTop: target.offset().top
          }, 1000, function() {
            // Callback after animation
            // Must change focus!
            //var $target = $(target);
            //$target.focus();
            //if ($target.is(":focus")) { // Checking if the target was focused
              //return false;
            //} else {
              //$target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
              //$target.focus(); // Set focus again
            //};
          });
        }
      }
    });

}

    return {
        init: init
    }

})();
