# Inline badge indicating a user's subscription tier (free or pro)

class Pom::SubscriptionBadgeComponent < Pom::Component
  option :pro, default: false

  define_styles(
    base: "inline-flex items-center px-2 py-0.5 text-xs font-semibold rounded-md",
    pro: {
      true: "bg-lime-500 text-white",
      false: "bg-slate-500 text-white"
    }
  )

  def default_options
    {
      class: styles_for(pro: pro)
    }
  end
end
