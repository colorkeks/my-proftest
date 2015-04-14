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
//= require jquery_ujs
//= require twitter/bootstrap
//= require dropzone
//= require jquery.rowsorter.min.js
//= require tinymce-jquery
//= require jquery.timers.js
//= require moment
//= require bootstrap-datetimepicker
//= require moment/ru
//= require turbolinks
//= require_tree .


function init_wysiwyg() {
    tinymce.init({
        selector: ".edit",
        statusbar: false,
        menubar: false
    });

    tinymce.init({
        selector: ".edit_hint",
        statusbar: false,
        menubar: false,
        setup: function (ed) {
            ed.on('init', function(args) {
                var id = ed.id;
                var height = 50;

                document.getElementById(id + '_ifr').style.height = height + 'px';
            });
        }
    });

//    $('.edit').editable({
//        buttons: ['bold', 'italic', 'underline', 'formatBlock', 'sep', 'indent', 'outdent',
//            'insertOrderedList', 'insertUnorderedList', 'insertImage', 'blockStyle'],
//        // How many colors on a line.
//        colorsStep: 6,
//        inlineMode: true,
//        alwaysVisible: true,
//        paragraphy: false,
//        placeholder: 'Введите вариант ответа'
//    });
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
    new_id = new_id || 1
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().before($("." + table_name).append(content.replace(regexp, new_id)));
    off_on(table_name);
}

function off_on(table_name){
    $('.radio-btn').off();
    $(".edit_hint").off();
    $(".edit").off();
    $('upper').off();
    $('downer').off();
    $('lefter').off();
    $('righter').off();
    init_wysiwyg();
    init_nested_form();
    upper_downer();
    row_index(table_name);
}

function row_index(table_name, index) {
    // это для кнопок удаления и вверз вниз
    if (table_name == null) {
        $(".answer_table tr:visible td:first-child").each(function (index) {
            $(this).text(index + 1)
        })
        $(".associate_table tr:visible td:first-child").each(function (index) {
            $(this).text(index + 1)
        })
        $(".task_contents_table tr:visible td:first-child").each(function (index) {
            $(this).text(index + 1)
        })
        $(".answer_table tr:visible .serial_number").each(function (index) {
            $(this).val(index + 1)
        })
        $(".associate_table tr:visible .serial_number").each(function (index) {
            $(this).val(index + 1)
        })
    }
    // а это для создания строк и вставки в конкретную таблицу
    else {
        $("." + table_name + " tr:visible td:first-child").each(function (index) {
            $(this).text(index + 1)
        })
        $("." + table_name + " tr:visible .serial_number").each(function (index) {
            $(this).val(index + 1)
        })
    }
}

function disable_select(){
    $('.association_select').change(function () {
        $('.association_select').each(function () {
            $('option').show()
        })
        $('.association_select option:selected').each(function () {
            if ($(this).text() == 'Не выбрано') {
            }
            else {
                $('.association_select option[value="' + $(this).val() + '"]').hide()
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

function algoritm_selects(){
        $('.algoritm').change(function () {
            var str = "";
            $(".algoritm option:selected").each(function () {
                if ($(this).text() == 'Адаптивный выбор') {
                    $('.adaptive_options').removeClass('hide')
                }
                else {
                    $('.adaptive_options').addClass('hide')
                }
            });
            $(".algoritm option:selected").each(function () {
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
        if (parseInt($('.seconds_timer').text()) >= 59) {
            $('.seconds_timer').text(0);
            if  (parseInt($('.minutes_timer').text()) >= 59) {
                $('.minutes_timer').text(0)
                $('.hours_timer').text(parseInt($('.hours_timer').text()) + 1);
            }
            else {
                $('.minutes_timer').text(parseInt($('.minutes_timer').text()) + 1)
            }
        }
        else {
            $('.seconds_timer').text(parseInt($('.seconds_timer').text()) + 1)
        }
    });
}

function upper_downer(){
    $('.upper').click(function(eventObject){
        var curr_tr = $(this).parent().parent();
        var prev_tr = $(curr_tr).prev();
        prev_tr.insertAfter(curr_tr);
        row_index();
    });
    $('.downer').click(function(eventObject) {
        var curr_tr = $(this).parent().parent();
        var next_tr = $(curr_tr).next();
        next_tr.insertBefore(curr_tr);
        row_index();
    });
    $(".answer_table").rowSorter({
        handler: "td.sorter",
        onDragStart: function(tbody, row, new_index, old_index){
            $('.answer_table tr td:first-child').css('opacity','0.0')
        },
        onDrop: function(tbody, row, new_index, old_index) {
            row_index();
            $('.answer_table tr td:first-child').css('opacity','1')
        }
    });
    $(".associate_table").rowSorter({
        handler: "td.sorter",
        onDragStart: function(tbody, row, new_index, old_index){
            $('.associate_table tr td:first-child').css('opacity','0.0')
        },
        onDrop: function(tbody, row, new_index, old_index) {
            row_index();
            $('.associate_table tr td:first-child').css('opacity','1')
        }
    });



//    $('.lefter').click(function(eventObject){
//        var curr_tr = $(this).parent().parent();
//        curr_tr.insertAfter($('.answer_table tr:visible:last'))
//    })
//    $('.righter').click(function(eventObject){
//        var curr_tr = $(this).parent().parent();
//        curr_tr.insertAfter($('.associate_table tr:visible:last'))
//    })
}
