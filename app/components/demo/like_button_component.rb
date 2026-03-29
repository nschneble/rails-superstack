class Demo::LikeButtonComponent < Pom::Component
  option :selected, default: false
  option :disabled, default: false
  option :path, required: true
  option :count, default: 0

  define_styles(
    base: "inline-flex items-center gap-1 px-2 py-1 text-xs font-medium ring-1 rounded-md",
    selected: {
      true: "bg-rose-500 hover:bg-rose-600 active:bg-rose-700 text-white ring-rose-500 hover:ring-rose-600 active:ring-rose-700",
      false: "bg-white hover:bg-rose-100 active:bg-rose-200 text-rose-500 ring-white hover:ring-rose-100 active:ring-rose-200"
    },
    disabled: {
      true: "disabled:bg-slate-100 disabled:text-slate-500 disabled:ring-slate-200 cursor-default",
      false: "cursor-pointer"
    }
  )

  def call
    button_to path, **html_options do
      safe_join([ helpers.fas_icon("heart"), tag.span(count) ])
    end
  end

  private

  def html_options
    merge_options(
      {
        class: styles_for(selected: selected, disabled: disabled),
        method: selected ? :delete : :post,
        disabled: disabled
      },
      extra_options
    )
  end
end
