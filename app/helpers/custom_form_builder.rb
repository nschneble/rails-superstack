class CustomFormBuilder < ActionView::Helpers::FormBuilder
  FORM_CLASSES = %w[
    max-w-[650]
    mx-4
    sm:mx-auto
    pt-8
    pb-16
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
    text-3xl
    tracking-tight
    cursor-default
    select-none
  ]

  LABEL_CLASSES = %w[
    block
    w-3/4
    sm:w-full
    max-w-[325]
    mx-auto
    text-sm
    select-none
  ]

  INPUT_CLASSES = %w[
    block
    w-3/4
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

  BUTTON_CLASSES = %w[
    block
    w-3/4
    sm:w-full
    max-w-[325]
    mx-auto
    my-4
    px-4
    py-2
    bg-slate-800
    disabled:bg-slate-300
    hover:bg-slate-900
    active:bg-slate-950
    disabled:text-black/50
    rounded-md
    cursor-pointer
    disabled:cursor-default
  ]

  def label(method, text = nil, options = {}, &block)
    super(method, text, options.merge(class: LABEL_CLASSES), &block)
  end

  def text_field(method, options = {})
    super(method, options.merge(class: INPUT_CLASSES))
  end

  def email_field(method, options = {})
    super(method, options.merge(class: INPUT_CLASSES))
  end

  def submit(value = nil, options = {})
    super(value, options.merge(class: BUTTON_CLASSES))
  end
end
