module ApplicationHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function('<i class="fa fa-times"></i>'.html_safe, 'remove_fields(this)', :class => 'btn btn-sm btn-white tooltips', title: 'Удалить' )
  end

  def link_to_add_fields(name, f, association,table_name)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function('<i class="fa fa-plus"></i>'.html_safe,
                     "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{table_name}\")",
                     :class => 'btn btn-white btn-sm pull-right tooltips')
  end
end
