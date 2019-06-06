// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require underscore
//= require jquery
//= require jquery_ujs
//= require jquery.mask
//= require jquery.detect_swipe
//= require picker
//= require jquery.tabslet.min
//= require picker.date
//= require picker.time
//= require picker.de_DE
//= require leaflet
//= require leaflet-providers
//= require leaflet.activearea
//= require featherlight
//= require featherlight.gallery
//= require enquire
//= require jquery.sumoselect
//= require jquery.jeditable
//= require jquery.jeditable.autogrow
//= require jquery.dropdown
//= require typeahead.bundle
//= require jquery.noty.packaged
//= require masonry.pkgd.min
//= require imagesloaded
//= require jquery.tagsinput
//= require linkify.min
//= require linkify-jquery.min
//= require jquery.remotipart
//= require lightslider
//= require modernizr.custom
//= require fastclick
//= require autogrow
//= require datatables.min
//= require timetable
//= require moment-with-locales.min
//= require datetime-moment
//= require Chart.min
//= require cocoon
//= require refile
//= require cookieconsent
//= require FileAPI.core
//= require FileAPI.Image
//= require_directory ./utils
//= require_directory ./components
//= require_directory ./controllers



$(document).on('ready', function(event) {
    APP.init();
});
