class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  attr_reader :template
  attr_reader :object
  attr_reader :object_name

  def field_item(attribute, li_class = nil, text = nil, &block)
    template.content_tag :li, :class => li_class do
      template.concat template.label(object_name, attribute, text)
      yield
    end
  end

  def check_item(attribute, li_class = nil, text = nil, &block)
    template.content_tag :li, :class => li_class do
      yield
      template.concat template.label(object_name, attribute, text, :class => 'label_for_check')
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

  def text_field_item(attribute, wrapper_class = nil, *args)
    field = text_field(attribute, *args)
    #template.text_field_tag(attribute, object.send(attribute), *args)
    field_item(attribute, wrapper_class) do
      template.concat field
      template.concat error_span(attribute)
    end
  end

  def email_field_item(attribute, wrapper_class = nil, *args)
    field = email_field(attribute, *args)
    #template.email_field_tag(attribute, object.send(attribute), *args)
    field_item(attribute, wrapper_class) do
      template.concat field
    end
  end

  def number_field_item(attribute, wrapper_class = nil, *args)
    field = number_field(attribute, *args)
    #template.number_field_tag(attribute, object.send(attribute), *args)
    field_item(attribute, wrapper_class) do
      template.concat field
    end
  end

  def select_field_item(attribute, coll_select, coll_key, coll_name, wrapper_class = nil, *args)
    collection = template.options_from_collection_for_select(coll_select, coll_key, coll_name)
    field = select(attribute, collection, *args)
    #template.select_tag(attribute, collection, *args)
    field_item(attribute, wrapper_class) do
      template.concat field
    end
  end

  def check_box_item(attribute, text, wrapper_class = nil, *args)
    field = check_box(attribute, *args)
    check_item(attribute, wrapper_class, text) do
      template.concat field
    end
  end

end