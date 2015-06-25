module PaperTrail
  module VersionConcern
    def item_version
      model = self.reify

      attrs = {}
      if changeset
        changeset.each do |k, v|
          attrs = attrs.merge({k => v[1]})
        end
      end

      if !model
        inheritance_column_name = item_type.constantize.inheritance_column
        class_name = attrs[inheritance_column_name].blank? ? item_type : attrs[inheritance_column_name]
        klass = class_name.constantize
        model = klass.new
      end

      attrs.each do |k, v|
        if model.has_attribute?(k)
          model[k.to_sym] = v
        elsif model.respond_to?("#{k}=")
          model.send("#{k}=", v)
        else
          logger.warn "Attribute #{k} does not exist on #{item_type} (Version id: #{id})."
        end
      end

      model
    end

  end
end