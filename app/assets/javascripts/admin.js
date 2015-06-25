//= require jquery
//= require jquery_ujs
//= require jquery-migrate-1.2.1.min
//= require twitter/bootstrap
//= require Sortable
//= require Answers
//= require custom
//= require tinymce-jquery
//= require jquery.timers.js
//= require moment
//= require bootstrap-datetimepicker
//= require moment/ru
//= require bootstrap-datetimepicker

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
    date_picker();
});

function date_picker(){
    $('#birthday').datetimepicker({
        locale : 'ru',
        format: 'DD-MM-YYYY'
    });
    $('#datetimepicker').datetimepicker({
        format: 'LT',
        locale: 'ru'
    });
};

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

function check_li(selector, condition){
    var elements = $(selector);
    elements.each( function() {
        var li = $(this);
        var a = li.children('a');
        if (condition) {
            li.removeClass('disabled');
            a.attr('onclick', a.attr('data-onclick'));
        } else {
            li.addClass('disabled');
            a.attr('onclick', 'return false;');
        }
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

        var trs = checked.closest('tr');
        var ids = [];
        var chains = {};
        var chains_count = 0;
        var sections = {};
        var sections_count = 0;
        var last_section_id = '';
        var tasks_without_chain_count = 0;

        trs.each(function( index, element ){
            var id = $(element).attr('data-id');
            ids.push(id);
            var chain_id = $(element).attr('data-chain-id');
            if (chain_id) {
                var chain_task_count = $(element).attr('data-chain-tasks-count');
                var chain = chains[chain_id];
                //console.log(chain);
                if (!chain) {
                    chain = {total: chain_task_count, selected: 0};
                    chains[chain_id] = chain;
                }
                chain.selected += 1;
            } else {
                tasks_without_chain_count++;
            }
            var section_id = $(element).attr('data-section-id');
            var section = sections[section_id];
            if (!section) {
                section = {};
                sections[section_id] = section;
            }

        });

        var incomplete_chains_flag = false;
        for (var ch in chains) {
            if (chains.hasOwnProperty(ch)){
                //console.log(ch);
                if (chains[ch].total != chains[ch].selected) incomplete_chains_flag = true;
                chains_count++;
            }
        }

        for (var s in sections) {
            if (sections.hasOwnProperty(s)){
                last_section_id = s;
                sections_count++;
            }
        }
        //console.log('sections_count: '+sections_count);

        //console.log('flag: '+incomplete_chains_flag);
        //Кнопка переноса
        if (checked.length > 0 && !window.selected_chain && !incomplete_chains_flag){
            $('#move-btn').removeClass('disabled');
        } else {
            $('#move-btn').addClass('disabled');
        }

        //Кнопка объединить в цепочку
        check_li('#join-chain-li', (checked.length > 0 && chains_count == 0 && sections_count == 1));

        //Кнопка переместить в цепочку
        check_li('#move-to-chain-li', (checked.length > 0));

        //Кнопка убрать из цепочки
        check_li('#remove-chain-li', (checked.length > 0 && tasks_without_chain_count == 0));

        //Кнопка разъединить
        check_li('#split-chain-li', (checked.length > 0));

        //Группы
        //Если выбран один раздел, то включаем группы из этого раздела
        //$('.change-eqvgroup-li')
        check_li('.change-eqvgroup-li', false);
        //alert(last_section_id);
        if (sections_count == 1 && !incomplete_chains_flag) {
            check_li('.change-eqvgroup-li[data-section-id="'+ last_section_id +'"]', true);
        }

    }
}

function highlight(){
    var answer_table = $("#answer_table");

    if(answer_table.length){
        answer_table.find("input[type='radio']").off('change').change(function(){ highlight_rows("success",  this )});
        answer_table.find("input[type='checkbox']").off('change').change(function(){ highlight_rows("success")});
        highlight_rows("success")
    }
}

function highlight_rows(hilight_class, current_element){

    var selector = 'td';
    $( "tr").removeClass( hilight_class );

    if (current_element){
        $(current_element).closest('tr').addClass(hilight_class);
    }else{
        $( "tr:has(" + selector + " input[type='checkbox']:checked)").addClass( hilight_class );
        $( "tr:has(" + selector + " input[type='radio']:checked)" ).addClass( hilight_class );
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
            editor.on('init', function()
            {
                this.getDoc().body.style.fontSize = '13px';
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


