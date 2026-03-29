class Pom::SubscriptionCardComponent < Pom::Component
  option :plan, required: true
  option :emphasis, enums: [ :emerald, :slate ], default: :slate
  option :term, enums: [ :monthly, :yearly ], default: :yearly
  option :checkmark_icon, default: "check"

  define_styles(
    base: "relative flex flex-col p-8 bg-blue-900 text-white rounded-xl shadow-xl",
    emphasis: {
      emerald: "md:-mt-4 md:mb-4 border-3 border-emerald-400",
      slate: "border border-slate-600"
    }
  )

  define_styles(
    :emphasis,
    label: {
      emerald: "text-emerald-400",
      slate: "text-slate-400"
    },
    submit: {
      emerald: "bg-emerald-400! hover:bg-emerald-500! active:bg-emerald-600! text-slate-900",
      slate: "bg-slate-800 hover:bg-slate-900 active:bg-slate-950 text-inherit"
    }
  )

  def default_options
    {
      class: styles_for(emphasis: emphasis)
    }
  end

  def card_is_active_plan?
    subscription_plan = helpers.current_user&.subscription_plan
    return false unless subscription_plan.present?

    subscription_plan.start_with?(plan.key.to_s) && subscription_plan.end_with?(term.to_s)
  end

  def stripe_price_id
    plan.stripe_price_id(term)
  end
end
