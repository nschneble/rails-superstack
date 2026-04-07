# Settings tab navigation button

class Pom::TabButtonComponent < Pom::Component
  option :tab, enums: [ :api, :billing, :profile ], default: :profile
  option :icon, default: "bookmark"
  option :path, required: true
  option :active, default: false

  define_styles(
    base: "group inline-flex items-center px-3 py-2 text-sm font-medium no-underline!",
    active: {
      true: "border-b-3 border-b-blue-900 text-blue-900 pointer-events-none",
      false: "border-b-3 border-b-white text-slate-600 hover:border-b-slate-600"
    }
  )

  def default_options
    {
      class: styles_for(active: active),
      data: {
        turbo_frame: "settings",
        turbo_action: "replace"
      },
      id: "settings-tab-#{tab}",
      role: "tab",
      aria: {
        selected: active,
        controls: "settings-panel-#{tab}"
      }
    }
  end
end
