//= require jquery
//= require jquery_ujs
//= require jquery-migrate-1.2.1.min
//= require twitter/bootstrap
//= require Sortable
//= require custom

$(function(){
    $("a[rel~=popover], .has-popover").popover();
    $("a[rel~=tooltip], .has-tooltip").tooltip();

    var check_box_list = $('.element_checkbox');
    $('#toggle-checkboxes').click(function(){
       var btn_cb = $(this).find('input[type="checkbox"]');
       btn_cb.prop('checked', !btn_cb.prop('checked'));
        check_box_list.prop('checked', btn_cb.prop('checked'));

    }).find('input[type="checkbox"]').click(function(){
        check_box_list.prop('checked', $(this).prop('checked'));
    });

});
