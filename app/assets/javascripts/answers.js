/**
 * Created by pavel on 18.06.15.
 */
//= require Sortable

function upper_downer() {
    $('#answer_body, #associate_body, #items').each(function(index, element){
        Sortable.create(element, {
            handler: 'sorter',
            animation: 150,
            onSort: function (evt) {
                row_index();
//                change_content();
            }
        });
    });
}

function date_picker(){
    $('#birthday').datetimepicker({
        locale : 'ru',
        format: 'YYYY-MM-DD'
    });
    $('#datetimepicker').datetimepicker({
        format: 'LT',
        locale: 'ru'
    });
}

function timer(raw_time, redirect_url){
    var SEC_IN_MINUTE = 60;
    var SEC_IN_HOUR   = 60 * SEC_IN_MINUTE;
    var seconds_element = $('.seconds_timer');
    var minutes_element = $('.minutes_timer');
    var hours_element   = $('.hours_timer');

    var interval = setInterval(function() {
        raw_time -= 1;
        if (raw_time < 1){
            clearInterval(interval);
            window.location = redirect_url;
            // todo редирект на страницу с сообщением о том что время вышло
        }
        var hours   = parseInt(raw_time / SEC_IN_HOUR);
        var minutes = parseInt((raw_time - (hours * SEC_IN_HOUR)) / SEC_IN_MINUTE);
        var seconds = parseInt(raw_time - (hours * SEC_IN_HOUR + minutes * SEC_IN_MINUTE));

        hours_element.text(hours);
        minutes_element.text(minutes);
        seconds_element.text(seconds);
    }, 1000);
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


function tasks_list(){
    $('#show-q-btns').click(function () {
        $('#q-btns').toggleClass('hide');
    });
}

function tab_selected(){
    $('.item').click(function () {
        $('.item').removeClass('selected');
        $(this).addClass('selected');
    })
}

function algorithm_selects(){
    function a(element) {
        if ($(element).val() == 'Ограниченое количество заданий') {
            $('.limited_options').removeClass('hide')
        }
        else {
            $('.limited_options').addClass('hide')
        }
    };
    $('.algorithm').change(function(){a(this);});
    a($('.algorithm'));
}

function fill_placeholder_in_open_answer(){
    var q_content = $('#question-content');
    var q_text = q_content.text();

    if(q_text){
        $('#user_answer').keyup(function(){
            var value = ' <span class="highlight">&nbsp;' + $(this).val() + '&nbsp;</span> ';
            setTimeout(function(){
                q_content.html(q_text.replace(/_(.*)_/, value));
            }, 1);
        });
    }
}
