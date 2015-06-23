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
    $('#date_beg').datetimepicker({
        locale : 'ru',
        format: 'DD-MM-YYYY'
    });
    $('#date_end').datetimepicker({
        locale : 'ru',
        format: 'DD-MM-YYYY'
    });
    $('#birthday').datetimepicker({
        locale : 'ru',
        format: 'DD-MM-YYYY'
    });
};

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

