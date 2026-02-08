module Pom
  class CopyToClipboardComponent < Pom::Component
    option :align, enums: [ :default, :left, :right ], default: :default
    option :target, required: false, default: nil
    option :theme, enums: [ :dark, :light ], default: :dark
    option :text, required: false, default: nil

    define_styles(
      base: "p-2 cursor-pointer",
      align: {
        default: "rounded-sm",
        left: "absolute top-0 left-0 rounded-tl-sm rounded-bl-sm",
        right: "absolute top-0 right-0 rounded-tr-sm rounded-br-sm"
      },
      theme: {
        dark: "bg-slate-800 hover:bg-slate-950 text-white",
        light: "bg-white hover:bg-slate-100 text-slate-800"
      }
    )

    def default_options
      {
        class: styles_for(align: align, theme: theme),
        data: {
          controller: "clipboard",
          action: "click->clipboard#copy",
          clipboard_duration_value: "1000",
          clipboard_emoji_fallback_value: !helpers.font_awesome_available?,
          clipboard_target_selector_value: target,
          clipboard_text_value: text
        }
      }
    end
  end
end
