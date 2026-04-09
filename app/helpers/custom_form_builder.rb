# Adds Tailwind styles to form labels, inputs, and buttons

# :reek:DataClump — (method, options) is the Rails FormBuilder convention; cannot change the signature
# :reek:TooManyConstants — CSS class arrays belong together here; splitting would scatter related styling
class CustomFormBuilder < ActionView::Helpers::FormBuilder
  FORM_CLASSES = %w[
    max-w-[650]
    mx-4
    sm:mx-auto
    pt-8
    pb-12
    sm:pb-16
    bg-blue-900
    border
    border-slate-600
    text-white
    shadow-slate-600
    shadow-xl
    rounded-md
  ]

  TITLE_CLASSES = %w[
    block
    mx-auto
    mb-8
    font-semibold
    text-center
    text-2xl
    sm:text-3xl
    tracking-tight
    cursor-default
    select-none
  ]

  LABEL_CLASSES = %w[
    block
    w-4/5
    sm:w-full
    max-w-[325]
    mx-auto
    text-sm
    select-none
  ]

  INPUT_CLASSES = %w[
    block
    w-4/5
    sm:w-full
    max-w-[325]
    mx-auto
    my-1
    px-2
    py-1
    bg-white
    disabled:bg-slate-100
    border-2
    border-white
    disabled:border-slate-100
    focus:border-slate-800
    text-slate-800
    disabled:text-slate-500
    outline-none
    rounded-md
  ]

  TEXT_AREA_CLASSES = %w[
    block
    w-4/5
    sm:w-full
    max-w-[325]
    mx-auto
    my-1
    px-2
    py-1
    bg-white
    disabled:bg-slate-100
    border-2
    border-white
    disabled:border-slate-100
    focus:border-slate-800
    text-slate-800
    disabled:text-slate-500
    outline-none
    resize-none
    rounded-md
  ]

  BUTTON_CLASSES = %w[
    block
    w-4/5
    sm:w-full
    max-w-[325]
    mx-auto
    my-4
    px-4
    py-3
    bg-slate-800
    disabled:bg-slate-800/80
    hover:bg-slate-900
    active:bg-slate-950
    text-white
    disabled:text-white/80
    text-sm
    font-semibold
    rounded-md
    cursor-pointer
    disabled:cursor-default
  ]

  EXTRA_WIDE_CLASSES = %w[
    max-w-[525]
  ]

  def label(method, text = nil, options = {}, &block)
    super(method, text, apply_classes(options, LABEL_CLASSES), &block)
  end

  %i[email_field text_field].each do |field_type|
    define_method(field_type) do |method, options = {}|
      super(method, apply_classes(options, INPUT_CLASSES))
    end
  end

  def text_area(method, options = {})
    super(method, apply_classes(options, TEXT_AREA_CLASSES))
  end

  def submit(value = nil, options = {})
    super(value, apply_classes(options, BUTTON_CLASSES))
  end

  private

  def apply_classes(options, classes)
    options.merge(class: [ classes, options[:class] ])
  end
end
