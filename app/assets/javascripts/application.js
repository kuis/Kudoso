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
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery.ui.all
//= require scrolling_nav
//= require best_in_place
//= require jquery.purr
//= require best_in_place.purr
//= require turbolinks
//= require recurring_select
//= require highcharts/highcharts
//= require cocoon
//= require bootstrap-sprockets
//= require_tree .




function ready() {
    $('.header').stickyNavbar({
        activeClass: 'active', // Class to be added to highlight nav elements
        sectionSelector: 'scrollto', // Class of the section that is interconnected with nav links
        animDuration: 350, // Duration of jQuery animation as well as jQuery scrolling duration
        navOffset: 50,
        startAt: 80, // Stick the menu at XXXpx from the top of the this() (nav container)
        easing: 'swing', // Easing type if jqueryEffects = true, use jQuery Easing plugin to extend easing types - gsgd.co.uk/sandbox/jquery/easing
        animateCSS: false, // AnimateCSS effect on/off
        animateCSSRepeat: false, // Repeat animation everytime user scrolls
        cssAnimation: 'fadeInDown', // AnimateCSS class that will be added to selector
        jqueryEffects: false, // jQuery animation on/off
        jqueryAnim: 'slideDown', // jQuery animation type: fadeIn, show or slideDown
        selector: 'li', // Selector to which activeClass will be added, either 'a' or 'li'
        mobile: false, // If false, nav will not stick under viewport width of 480px (default) or user defined mobileWidth
        mobileWidth: 480, // The viewport width (without scrollbar) under which stickyNavbar will not be applied (due user usability on mobile)
        zindex: 9999, // The zindex value to apply to the element: default 9999, other option is 'auto'
        stickyModeClass: 'sticky', // Class that will be applied to 'this' in sticky mode
        unstickyModeClass: 'unsticky' // Class that will be applied to 'this' in non-sticky mode
    });
    $(document).ajaxError(function (e, xhr, settings) {
        if (xhr.status == 401) {
            location.reload();
        }
    });
}
$(function() {

    $(document).ready(ready);
    $(document).on('page:load', ready);
    jQuery(".best_in_place").best_in_place();
    $('a.close').click(function(){
       $(this.parentNode).hide(500);
    });
    $('#nav').affix({
        offset: {
            top: $('header').height()
        }
    });
});
