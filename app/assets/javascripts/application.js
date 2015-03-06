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
//= require froala_editor.min.js
//= require turbolinks
//= require_tree .


function init_dropzone(){
    Dropzone.autoDiscover = false;
    myDropzone = new Dropzone(".dropzone", { // Make the whole body a dropzone
        maxFilesize: 64, // макс размер в MB
        //acceptedFiles: ".jpeg,.jpg,.png,.gif,.JPEG,.JPG,.PNG,.GIF",
        acceptedMimeTypes: null,
        autoProcessQueue: false, // автозагрузка в бд
        autoQueue: true,
        url: "/task_content",
        previewsContainer: null,
        paramName: "task_content[file_content]", // парамс
        addRemoveLinks: true, // удаление выбранных картинок
        dictFallbackMessage: "Ваш браузер не поддерживает drag and drop загрузки",
        dictFallbackText: "Please use the fallback form below to upload your files like in the olden days.",
        dictFileTooBig: "Файл Слишком большой ({{filesize}}MiB). Максимальный размер: {{maxFilesize}}MiB.",
        dictInvalidFileType: "Невозможно загрузить файл с таким типом",
        dictResponseError: "Server responded with {{statusCode}} code.",
        dictCancelUpload: "Отмена загрузки",
        dictCancelUploadConfirmation: "Вы хотите отменить эту загрузку ?",
        dictRemoveFile: "Убрать файл",
        dictRemoveFileConfirmation: null,
        dictMaxFilesExceeded: "Вы не можете загружать больше файлов"

    });
}
function init_wysiwyg() {
    $('.edit').editable({
        buttons: ['bold', 'italic', 'underline', 'formatBlock', 'sep', 'indent', 'outdent',
            'insertOrderedList', 'insertUnorderedList', 'insertImage', 'blockStyle'],
        // How many colors on a line.
        colorsStep: 6,
        inlineMode: true,
        alwaysVisible: true,
        paragraphy: false
    });
}
function init_nested_form(){
    $('.radio-btn').click(function(){
        $('input:radio').prop('checked',false);
        $(this).prop('checked',true);
        console.log(this)
    })
    $('.delete_nested_form').click(function(){
        console.log(this.id)
        $('tr[id^="' + this.id + '"]').remove();
    })
}