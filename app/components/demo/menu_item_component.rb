module Demo
  class MenuItemComponent < Pom::Component
    option :theme, enums: [ :default, :secret ], default: :default
    option :path, required: true
    option :icon, required: true
    option :label, required: false

    define_styles(
      base: "flex items-center gap-2 px-4 py-2 text-sm hover:no-underline!",
      theme: {
        default: "text-slate-900 hover:bg-slate-100",
        secret: "text-pink-600 hover:bg-pink-100"
      }
    )

    def call
      link_to path, **html_options do
        safe_join([helpers.fas_icon(icon), content_tag(:span, label || content)])
      end
    end

    private

    def html_options
      merge_options(
        {
          class: styles_for(theme: theme),
          data: { action: "dropdown#close" },
          role: "menuitem"
        },
        extra_options
      )
    end
  end
end
