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

    $('#show-preview').click(function(){
        $(this).closest('form').find('#preview-flag').val(true);
        $(this).closest('form').submit();

    });

    init_wysiwyg();
    init_nested_form();
    upper_downer();
    row_index();
    button_states();
    highlight();
    select_all();
    register_change_event();
    search_click();
});


function register_change_event(){
    if ($('#change-content').length > 0){
        $('input, textarea').keyup(function(){ change_content() });
        $('input[type="radio"], input[type="checkbox"]').click(function(){ change_content() });
    }
}

function change_content(){
    if (!window.change_status) {
        $('#change-content').text('Есть не сохраненные изменения');
        window.change_status = true;
    }
}


function select_all(){
    var check_box_list = $('.element_checkbox');
    $('#toggle-checkboxes').click(function(){
        var btn_cb = $(this).find('input[type="checkbox"]');
        btn_cb.prop('checked', !btn_cb.prop('checked'));
        check_box_list.prop('checked', btn_cb.prop('checked')).change();

    }).find('input[type="checkbox"]').click(function(){
        check_box_list.prop('checked', $(this).prop('checked')).change();
    });

}

function button_states(){
    show_hide();

    $('table input[type="checkbox"]').change(function(){
        show_hide()
    });

    function show_hide(){
        var checked = $('table input[type="checkbox"]:checked');
        var all = $('table input[type="checkbox"]');

        if (checked.length > 0){
            $('#move-btn, #remove-btn').removeClass('disabled');
        }else{
            $('#move-btn, #remove-btn').addClass('disabled');
        }

        if (checked.length == 1){
            $('#rename').removeClass('disabled').find('a').attr('onclick', 'editElement()');
            $('#change-position').removeClass('disabled');
        }else{
            $('#rename').addClass('disabled').find('a').attr('onclick', '');
            $('#change-position').addClass('disabled');
        }

        if (checked.length > 0 && checked.length != all.length){
            $('#toggle-checkboxes').find('.ckbox').addClass('minus').find('input').prop('checked', true);
        }else if(checked.length == all.length && all.length != 0){
            $('#toggle-checkboxes').find('.ckbox').removeClass('minus').find('input').prop('checked', true);
        }else if(checked.length == 0){
            $('#toggle-checkboxes').find('.ckbox').removeClass('minus').find('input').prop('checked', false);
        }
    }
}

function highlight(){
    var answer_table = $("#answer_table");

    if(answer_table.length){
        answer_table.find("input[type='radio']").off('change').change(function(){ highlight_rows("success", null, this )});
        answer_table.find("input[type='checkbox']").off('change').change(function(){ highlight_rows("success")});
        highlight_rows("success")
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
        cleanup : true,
        paste_as_text: true,
        setup: function(editor) {
            editor.on('change', function(e) {
                change_content();
            });
        },

        toolbar: [
            "bold italic subscript superscript | bullist numlist  "
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
    $('.radio-btn').off('click').click(function(){
        $('input:radio').prop('checked', false);
        $('.radio_correct').prop('value', false);
        $(this).prop('checked', true);
        $('input[name^="' + this.name + '"]').prop('value', true)
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
    $(".edit_hint").off();
    $(".edit").off();
    init_wysiwyg();
    init_nested_form();
    row_index(table_name);
    highlight();
    change_content();
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
    $('#answer_body, #associate_body, #items').each(function(index, element){
        Sortable.create(element, {
            handler: 'sorter',
            animation: 150,
            onSort: function (evt) {
                row_index();
                change_content();
            }
        });
    });
}


function search_click(){
  $('#qwery_string').keyup(function(){
      clearTimeout(window.search_timer);
      var form = $(this).closest('form');
      window.search_timer = setTimeout(function(){
          $('#spinner').show();
          form.submit()
      }, 700);
  })
}


