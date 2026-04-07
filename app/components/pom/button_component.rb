# Full-width styled link button

class Pom::ButtonComponent < Pom::Component
  option :theme, enums: [ :slate, :emerald ], default: :slate
  option :size, enums: [ :base ], default: :base
  option :path, required: true
  option :disabled, default: false

  define_styles(
    base: "block w-4/5 sm:w-full max-w-[325] mx-auto my-4 px-4 font-semibold rounded-md",
    theme: {
      slate: "bg-slate-800 hover:bg-slate-900 active:bg-slate-950 text-white active:text-slate-100",
      emerald: "bg-emerald-400 hover:bg-emerald-500 active:bg-emerald-600 text-slate-900 active:text-slate-950"
    },
    size: {
      base: "py-3 text-sm"
    },
    disabled: {
      true: "disabled:bg-slate-800/80 disabled:text-white/80 disabled:cursor-default",
      false: "cursor-pointer"
    }
  )

  def default_options
    {
      class: styles_for(theme:, size:, disabled:),
      data: { turbo: false },
      disabled:
    }
  end
end
