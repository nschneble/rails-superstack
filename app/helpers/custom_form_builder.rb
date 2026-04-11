# Adds Tailwind styles to form labels, inputs, and buttons

class CustomFormBuilder < ActionView::Helpers::FormBuilder
  include TailwindHelper

  FORM_ELEMENTS = {
    email_field: :form_input_classes,
    text_field:  :form_input_classes,
    text_area:   :form_text_area_classes,
    submit:      :form_button_classes
  }

  def label(method, text = nil, options = {}, &block)
    super(method, text, apply_classes(options, form_label_classes), &block)
  end

  FORM_ELEMENTS.each do |field_type, classes_method|
    define_method(field_type) do |method, options = {}|
      super(method, apply_classes(options, send(classes_method)))
    end
  end

  private

  def apply_classes(options, classes)
    options.merge(class: [ classes, options[:class] ])
  end
end
