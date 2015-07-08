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
//= require jquery-ui
//= require jquery-ui/core
//= require jquery-ui/sortable
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.rowsorter.min.js
//= require tinymce-jquery
//= require jquery.timers.js
//= require moment
//= require bootstrap-datetimepicker
//= require moment/ru
//= require answers


$(function(){
    $("a[rel~=popover], .has-popover").popover();
    $("a[rel~=tooltip], .has-tooltip").tooltip();
    fill_placeholder_in_open_answer();
});
