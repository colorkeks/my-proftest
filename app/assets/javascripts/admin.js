//= require jquery
//= require jquery-migrate-1.2.1.min
//= require twitter/bootstrap
//= require Sortable
//= require custom

$(function(){
    $("a[rel~=popover], .has-popover").popover();
    $("a[rel~=tooltip], .has-tooltip").tooltip();
});
