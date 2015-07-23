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
        options.merge!(class: 'icon-open tooltips', title: 'Открытый вопрос')
      when task.is_a?(Chain)
        options.merge!(class: 'fa fa-link', title: 'Цепочка')
      else
    end

    tag tag_name, options
  end

  def human_time_from_seconds(total_seconds)
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)

    #format("%02d:%02d:%02d", hours, minutes, seconds) #=> "01:00:00"
    "#{hours} часов, #{minutes} минут"
  end

  def duration_strftime(duration, format)
    #duration in seconds
    Time.at(duration).utc.strftime(format)
  end

end
