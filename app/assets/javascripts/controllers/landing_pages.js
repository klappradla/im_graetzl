APP.controllers.landing_pages = (function() {

    function init() {
      if($('#lp_nav').exists()) initLP();
      if($("#lp_nav.-sticky").exists()) initStickyNav(); // Init if Section has '-sticky' Class
    }

// ---------------------------------------------------------------------- Public

    // Fixed Sticky-Nav on Scroll if Needed (add Class '-sticky' to <section>)
    var initStickyNav = function() {
      var lp_nav = $('#lp_nav'); // Navigation Bar
      var lp_content = $('.page'); // Page Content
      var topHeader = $('header').height(); // Top-Nav Grätzl Header
      var imgHeader = $('.imgHeader').height(); // Banner Image Area

      $(window).resize(function() {
        topHeader = $('header').height(); // Top-Nav Grätzl Header
        imgHeader = $('.imgHeader').height(); // Banner Image Area
      })

      $(window).scroll(function() {
        if( $(this).scrollTop() > topHeader + imgHeader ) {
          lp_nav.addClass('sticky');
          lp_content.addClass('sticky_content');
        } else {
          lp_nav.removeClass('sticky');
          lp_content.removeClass('sticky_content');
        }
      });
    } // Fixed Sticky-Nav on Scroll if Needed


    // LandingPage Navigation
    var initLP = function() {

      // Switch Pages on Button Click - DESKTOP Version
      $('button.pages').on( 'click', function() {
        var page = $(this).attr('data-nav');
        $('#lp_nav button.-active').removeClass('-active');
        //$(this).addClass('-active');

        //$('#lp_nav button').find("[data-nav='" + page + "']").addClass('-active');
        $('#lp_nav button[data-nav="'+page+'"]').addClass('-active');

        pageNav(page);
      }) // onClick

      // Page Nav Switcher
      var pageNav = function(page) {
        $('div.page').hide(); // Hide all Pages
        $('#' + page + '').fadeIn('fast', function(){
          if ( $('#lp_nav').hasClass( 'sticky' )) { // if StickNav scroll to Page
            $('html, body').animate({
              scrollTop:$(this).offset().top
            });
          }
        });
      } // Page Nav Switcher

      pageNav('page_home'); // Init Home on PageLoad



    } // LandingPage Navigation

    return {
        init: init
    }

})();
