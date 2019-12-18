APP.controllers.static_pages = (function() {

    function init() {
      if($("#help_nav").exists()) initHelpScroller();
      if($("section.homeOut").exists()) initMobileNav();
      if($(".-mentoring-page").exists()) initMentoring();
      if($("#guide-download").exists()) initGuideDownload();
    }

// ---------------------------------------------------------------------- Public

function initMentoring() {
  $(".-login").featherlight({});

  // Find question coworking and exchange ith radio buttons?
  //var question_coworking = $("h4:contains('2')").next('.input-textarea').children('textarea').first();
  //console.log(question_coworking);

  $( ".tischlerei-infos" ).hide();
  $( ".arrow" ).click(function() {
    $( ".tischlerei-infos" ).slideToggle(function() {
      $( ".arrow" ).toggleClass( "-up" );
    });
  });

  var roomGallery = new jBox('Image', {
    addClass:'jBoxGallery',
    imageCounter:true,
    preloadFirstImage:true,
    closeOnEsc:true,
    createOnInit:true,
    animation:{open: 'zoomIn', close: 'zoomOut'},
  });


  $('.group-info').hide();
  var selectedgroup = $('input[name=group]:checked').attr("id");
  $('.group-info.' + selectedgroup).show();

  // Radio Switch for Submitting in selected Group
  $('#group-switch input').on('change', function() {
    var groupaction = $('input[name=group]:checked').val();
    var group = $('input[name=group]:checked').attr("id");
    $('#groupform').attr('action', groupaction);

    $('.group-info').hide();
    $('.group-info.' + group).show();




  });


  // Button Switch for Submitting in selected Group
  /*
  $('#group-switch li').on('click', function(){
    $('#group-switch li').removeClass('active');
    $(this).addClass('active');
    var group = $(this).attr("id");
    var groupaction = $(this).attr("data-group");
    $('.group-info').slideUp();
    $('.group-info.' + group).slideDown();
    $('#groupform').attr('action', groupaction);
  })
  */

  // Change Wording of Notice Message for Mentoring Registrations
  if ($("#flash .notice").exists()) {
    if ( $("#flash .notice").text().indexOf('Vielen Dank für Deine Registrierung.') >= 0 ){
      // Modifiy Message for Mentoring
      $("#flash .notice").html('Vielen Dank für Deine Registrierung. Du bist nun angemeldet und kannst das <a href="#teilnahme">Teilnahme Formular</a> (unterhalb) ausfüllen.');
    }
  }

  if ($("#card-slider").exists()) {
    $('#card-slider').lightSlider({
      item: 2,
      autoWidth: false,
      slideMove: 2, // slidemove will be 1 if loop is true
      slideMargin: 15,
      addClass: '',
      mode: "slide",
      useCSS: true,
      cssEasing: 'ease', //'cubic-bezier(0.25, 0, 0.25, 1)',//
      easing: 'linear', //'for jquery animation',////
      speed: 750, //ms'
      auto: true,
      loop: true,
      slideEndAnimation: true,
      pause: 10000,
      keyPress: false,
      controls: false,
      prevHtml: '',
      nextHtml: '',
      adaptiveHeight:false,
      pager: true,
      //currentPagerPosition: 'middle',
      enableTouch:true,
      enableDrag:false,
      freeMove:true,
      swipeThreshold: 40,
      responsive : [
        {
          breakpoint:850,
          settings: {
            item: 2,
            slideMove: 2,
          }
        },
        {
          breakpoint:530,
          settings: {
            item: 1,
            slideMove: 1
          }
        }
      ]
    });
  }

}

function initGuideDownload() {
  $('#guide-download').on('click', function(){
    gtag('event', 'Download', {
      'event_category': 'Raumteiler-Guide'
    });
  });
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
    if($('#help_nav').offset().top + $('#help_nav').height() >= $('.filter-stream').offset().top )
      $('#help_nav').addClass( "fix_nav" ).removeClass( "float_nav" );
}

function initHelpScroller() {

  var elementPosition = $('#help_nav').offset();

  $(window).scroll(function(){
          if($(window).scrollTop() > elementPosition.top){
              $('#help_nav').addClass( "float_nav" ).removeClass( "fix_nav" );
              checkOffset();
          } else {
              $('#help_nav').removeClass( "fix_nav" ).removeClass( "float_nav" );
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
