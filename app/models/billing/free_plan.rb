module Billing
  FreePlan = Plan.new(
    key: :free,
    name: I18n.t("billing.plans.free.name"),
    description: I18n.t("billing.plans.free.description"),
    features: I18n.t("billing.plans.free.features")
  )
end
