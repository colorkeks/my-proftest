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
///= require froala_editor.min.js
//= require tinymce-jquery
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
}

function add_answers_fields(link, association, content) {
    var new_id = (parseInt($(".answer_table tr:visible:last td:first ").text()) + 1);
    new_id = new_id || 1
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().before($('.answer_table').append(content.replace(regexp, new_id)));
    $('.radio-btn').off();
    $(".edit_hint").off();
    $(".edit").off();
    init_wysiwyg();
    init_nested_form();
    row_index();

}

function row_index(index){
    $(".answer_table tr:visible td:first-child").each (function(index){
        $(this).text(index + 1)
    })
    $(".answer_table tr:visible .serial_number").each (function(index){
        $(this).val(index + 1)
    })
}

function add_task_contents_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g")
    $(link).parent().before($('.task_contents_table').append(content.replace(regexp, new_id)));
}