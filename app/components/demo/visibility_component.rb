class Demo::VisibilityComponent < Pom::Component
  option :visibility, required: true
  option :palette, enums: [ :default ], default: :default

  define_styles(
    base: "absolute bottom-2 inline-flex items-center mt-4 px-2 py-1 rounded-md select-none",
    palette: {
      default: "bg-slate-100 text-slate-500 text-xs font-medium ring-1 ring-slate-200"
    }
  )

  def call
    tag.span **html_options do
      safe_join([ helpers.fas_icon("eye"), tag.span(visibility, class: "ml-1 capitalize") ])
    end
  end

  private

  def html_options
    merge_options(
      {
        class: styles_for(palette: palette)
      },
      extra_options
    )
  end
end
