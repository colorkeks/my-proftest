//= require jquery
//= require jquery_ujs
//= require jquery-migrate-1.2.1.min
//= require twitter/bootstrap
//= require Sortable
//= require custom
//= require tinymce-jquery

$(function(){
    $("a[rel~=popover], .has-popover").popover();
    $("a[rel~=tooltip], .has-tooltip").tooltip();

    var check_box_list = $('.element_checkbox');
    $('#toggle-checkboxes').click(function(){
        var btn_cb = $(this).find('input[type="checkbox"]');
        btn_cb.prop('checked', !btn_cb.prop('checked'));
        check_box_list.prop('checked', btn_cb.prop('checked'));
        highlight_rows("selected", 'td > .ckbox');

    }).find('input[type="checkbox"]').click(function(){
        check_box_list.prop('checked', $(this).prop('checked'));
        highlight_rows("selected", 'td > .ckbox');
    });


    //if($("#answer_table").length){
    //    $(this).find("input[type='radio']").off().change(function(){ highlight_rows("success", null, this )});
    //    $(this).find("input[type='checkbox']").off().change(function(){ highlight_rows("success")});
    //    highlight_rows("success")
    //}
    //
    //if($("#test_list").length){
    //    $(this).find("input[type='checkbox']").off().change(function(){ highlight_rows("selected", 'td > .ckbox') });
    //    //highlight_rows("success")
    //}

    highlight();
    init_wysiwyg();
    init_nested_form();
    upper_downer();
    row_index();
});

function highlight(){
    var answer_table = $("#answer_table");
    var test_list = $("#test_list");

    if(answer_table.length){
        answer_table.find("input[type='radio']").off().change(function(){ highlight_rows("success", null, this )});
        answer_table.find("input[type='checkbox']").off().change(function(){ highlight_rows("success")});
        highlight_rows("success")
    }

    if(test_list.length){
        test_list.find("input[type='checkbox']").off().change(function(){ highlight_rows("selected", 'td > .ckbox') });
        //highlight_rows("success")
    }
}

function highlight_rows(hilight_class, checkbox_selector, current_element){

    var selector = checkbox_selector || 'td';
    $( "tr").removeClass( hilight_class );

    if (current_element){
        $(current_element).closest('tr').addClass(hilight_class);
    }else{
        $( "tr:has(" + selector + ">input[type='checkbox']:checked)").addClass( hilight_class );
        $( "tr:has(" + selector + ">input[type='radio']:checked)" ).addClass( hilight_class );
    }
}

function init_wysiwyg() {
    tinymce.init({
        selector: ".edit",
        statusbar: false,
        menubar: false,
        toolbar: [
            "undo redo | styleselect | bold italic | link image | alignleft aligncenter alignright"
        ]
    });

    //tinymce.init({
    //    selector: ".edit_hint",
    //    statusbar: false,
    //    menubar: false,
    //    setup: function (ed) {
    //        ed.on('init', function(args) {
    //            var id = ed.id;
    //            var height = 50;
    //
    //            document.getElementById(id + '_ifr').style.height = height + 'px';
    //        });
    //    }
    //});
}

function init_nested_form(){
    $('.radio-btn').click(function(){
        $('input:radio').prop('checked',false);
        $('.radio_correct').prop('value',false);
        $(this).prop('checked',true);
        $('input[name^="' + this.name + '"]').prop('value',true)
    })
}

function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("true");
    $(link).closest(".fields").hide();
    row_index();
    off_on();
}

function add_fields(link, association, content, table_name) {
    var new_id = (parseInt($("." + table_name + " tr:visible:last td:first ").text()) + 1);
    new_id = new_id || 1;
    var regexp = new RegExp("new_" + association, "g");
    $('#' + table_name).append(content.replace(regexp, new_id));
    off_on(table_name);
}

function time_picker(){
    $('#datetimepicker').datetimepicker({
        format: 'LT',
        locale: 'ru'
    });
}

function off_on(table_name){
    $('.radio-btn').off();
    $(".edit_hint").off();
    $(".edit").off();
    init_wysiwyg();
    init_nested_form();
    row_index(table_name);
    highlight();
}

function row_index(table_name, index) {
    // это для кнопок удаления и вверз вниз
    if (table_name == null) {
        $(".answer_table tr:visible td:first-child").each(function (index) { $(this).text(index + 1) });
        $(".associate_table tr:visible td:first-child").each(function (index) { $(this).text(index + 1) });
        $(".task_contents_table tr:visible td:first-child").each(function (index) { $(this).text(index + 1) });
        $(".answer_table tr:visible .serial_number").each(function (index) { $(this).val(index + 1) });
        $(".associate_table tr:visible .serial_number").each(function (index) { $(this).val(index + 1) });
    }
    // а это для создания строк и вставки в конкретную таблицу
    else {
        $("." + table_name + " tr:visible td:first-child").each(function (index) { $(this).text(index + 1) });
        $("." + table_name + " tr:visible .serial_number").each(function (index) { $(this).val(index + 1) });
    }
}

function disable_select(){
    $('.association_select').change(function () {
        $('.association_select').each(function () { $('option').show() });
        $('.association_select option:selected').each(function () {
            if ($(this).text() != 'Не выбрано') {
                $('.association_select option[value="' + $(this).val() + '"]').hide();
            }
        })
    });
}
function tab_selected(){
    $('.item').click(function () {
        $('.item').removeClass('selected');
        $(this).addClass('selected');
    })
}

function tasks_list(){
    $('#show-q-btns').click(function () {
        $('#q-btns').toggleClass('hide');
    });
}

function algorithm_selects(){
    $('.algorithm').change(function () {
        var str = "";
        $(".algorithm option:selected").each(function () {
            if ($(this).text() == 'Адаптивный выбор') {
                $('.adaptive_options').removeClass('hide')
            }
            else {
                $('.adaptive_options').addClass('hide')
            }
        });
        $(".algorithm option:selected").each(function () {
            if ($(this).text() == 'Ограниченое количество заданий') {
                $('.limited_options').removeClass('hide')
            }
            else {
                $('.limited_options').addClass('hide')
            }
        });
    });
}

function timer(){
    $(".seconds_timer").everyTime(1000, function() {
        if (parseInt($('.seconds_timer').text()) <= 0) {
            $('.seconds_timer').text(59);
            if  (parseInt($('.minutes_timer').text()) <= 0) {
                $('.minutes_timer').text(59);
                $('.hours_timer').text(parseInt($('.hours_timer').text()) - 1);
            }
            else { $('.minutes_timer').text(parseInt($('.minutes_timer').text()) - 1) }
        }
        else { $('.seconds_timer').text(parseInt($('.seconds_timer').text()) - 1) }
    });
}

function upper_downer() {
    $('#answer_body, #associate_body').each(function(index, element){
        console.log(element);
        Sortable.create(element, {
            handler: 'sorter',
            animation: 150,
            onSort: function (evt) {
                row_index();
            }
        });
    });
};


