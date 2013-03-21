class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  attr_reader :template
  attr_reader :object
  attr_reader :object_name

  def field_item(attribute, text = nil, &block)
    template.content_tag :li do
      template.concat template.label(object_name, attribute, text)
      yield
    end
  end

  def error_span(attribute, options = {})
    options[:class] ||= 'help-inline'

    template.content_tag(
        :span, self.errors_for(attribute),
        :class => options[:class]
    ) if self.errors_on?(attribute)
  end

  def errors_on?(attribute)
    self.object.errors[attribute].present? if self.object.respond_to?(:errors)
  end

  def errors_for(attribute)
    self.object.errors[attribute].try(:join, ', ')
  end

  def text_field_item(attribute, *args)
    field = text_field(attribute, *args)
    #template.text_field_tag(attribute, object.send(attribute), *args)
    field_item(attribute) do
      template.concat field
      template.concat error_span(attribute)
    end
  end

  def email_field_item(attribute, *args)
    field = email_field(attribute, *args)
    #template.email_field_tag(attribute, object.send(attribute), *args)
    field_item(attribute) do
      template.concat field
    end
  end

  def number_field_item(attribute, *args)
    field = number_field(attribute, *args)
    #template.number_field_tag(attribute, object.send(attribute), *args)
    field_item(attribute) do
      template.concat field
    end
  end

  def select_field_item(attribute, coll_select, coll_key, coll_name, *args)
    collection = template.options_from_collection_for_select(coll_select, coll_key, coll_name)
    field = select(attribute, collection, *args)
    #template.select_tag(attribute, collection, *args)
    field_item(attribute) do
      template.concat field
    end
  end

end