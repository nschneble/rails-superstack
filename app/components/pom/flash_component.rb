module Pom
  class FlashComponent < Pom::Component
    option :variant, enums: [ :alert, :notice ], default: :notice
    option :size, enums: [ :md ], default: :md

    define_styles(
      base: "relative flex justify-start items-center rounded opacity-0 transition-all duration-200",
      variant: {
        alert: "bg-pink-700 text-white shadow-slate-800",
        notice: "bg-emerald-700 text-white shadow-slate-800"
      },
      size: {
        md: "gap-x-2 mb-4 p-4 pr-8 text-sm shadow-lg -translate-y-4"
      }
    )

    def default_options
      {
        class: styles_for(variant: variant, size: size),
        data: {
          controller: "flash",
          flash_timeout_value: "10000",
          flash_duration_value: "200"
        }
      }
    end
  end
end
