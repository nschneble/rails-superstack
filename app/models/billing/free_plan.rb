module Billing
  # Singleton instance of a free subscription plan
  FreePlan = Plan.new(
    key: :free,
    name: I18n.t("billing.plans.free.name"),
    description: I18n.t("billing.plans.free.description"),
    price_monthly_cents: 0,
    price_yearly_cents: 0,
    stripe_price_monthly_id: nil,
    stripe_price_yearly_id: nil,
    features: I18n.t("billing.plans.free.features")
  )
end
