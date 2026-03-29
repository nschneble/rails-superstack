module Billing
  ProPlan = Plan.new(
    key: :pro,
    name: I18n.t("billing.plans.pro.name"),
    description: I18n.t("billing.plans.pro.description"),
    price_monthly_cents: 1000,
    price_yearly_cents: 9600,
    stripe_price_monthly_id: -> { Figaro.env.stripe_price_pro_monthly },
    stripe_price_yearly_id: -> { Figaro.env.stripe_price_pro_yearly },
    features: I18n.t("billing.plans.pro.features")
  )
end
