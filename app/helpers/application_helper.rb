module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => 'btn btn-danger')
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    if association == :answers
      link_to_function(name, "add_answers_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => 'btn btn-default')
    else
      link_to_function(name, "add_task_contents_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => 'btn btn-default')
    end
  end
end
