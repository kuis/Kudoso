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
//= require jquery-rangeSelector
//= require best_in_place
//= require turbolinks
//= require recurring_select
//= require highcharts/highcharts
//= require cocoon
//= require analytics
//= require_tree .




function ready() {

    $(document).ajaxError(function (e, xhr, settings) {
        if (xhr.status == 401) {
            location.reload();
        }
    });
    if (typeof(setupRangeSelector) == 'function')
        setupRangeSelector();

    $('.k-page-header').attr("data-uk-sticky", "{top:-" + window.screen.height/2 +  ", animation: 'uk-animation-slide-top'}");

}
$(function() {

    $(document).ready(ready);
    $(document).on('page:load', ready);
    jQuery(".best_in_place").best_in_place();
    $('a.close').click(function(){
       $(this.parentNode).hide(500);
    });

    $(".signup").keyup(function (e) {
        if (e.keyCode == 13) {
            signup();
        }
    });
});

$(document).on("page:load ready", function(){
    $("input.datepicker").datepicker();
});

function validateEmail(email) {
    var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    return re.test(email);
}