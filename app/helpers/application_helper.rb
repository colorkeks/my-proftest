module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name.html_safe, 'remove_fields(this)', :class => 'btn btn-sm btn-white tooltips', title: 'Удалить' )
  end

  def link_to_add_fields(name, f, association,table_name, options)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name.html_safe,
                     "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{table_name}\")",
                     options,
                     # :class => 'btn btn-white btn-sm pull-right tooltips'
    )
  end

  def task_type_icon_class(task, tag_name='span', options={})
    case task.task_type
      when 'Единичный выбор'
        options.merge!(class: 'icon-single tooltips', title: 'Единичный выбор')
      when 'Последовательность'
        options.merge!(class: 'icon-sequence tooltips', title: 'Последовательность')
      when 'Множественный выбор'
        options.merge!(class: 'icon-mutli tooltips', title: 'Множественный выбор')
      when 'Сопоставление'
        options.merge!(class: 'icon-connect tooltips', title: 'Сопоставление')
      when 'Открытый вопрос'
        options.merge!(class: 'icon-connect open', title: 'Открытый вопрос')
      when task.is_a?(Chain)
        options.merge!(class: 'fa fa-link', title: 'Цепочка')
      else
    end
    p '+++'
    p tag_name
    tag tag_name, options
  end

end
