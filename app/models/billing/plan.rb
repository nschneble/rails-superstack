module Billing
  # Immutable value object describing a subscription plan
  Plan = Data.define(
    :key,
    :name,
    :description,
    :price_monthly_cents,
    :price_yearly_cents,
    :stripe_price_monthly_id,
    :stripe_price_yearly_id,
    :features
  ) do
    include Draper::Decoratable

    def free?
      price_monthly_cents.zero? && price_yearly_cents.zero?
    end
  end
end
