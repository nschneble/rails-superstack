module Billing
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

    def initialize(
      key:,
      name:,
      description: "",
      price_monthly_cents: 0,
      price_yearly_cents: 0,
      stripe_price_monthly_id: nil,
      stripe_price_yearly_id: nil,
      features: [])
      super
    end

    def free?
      key == :free
    end

    def pro?
      key == :pro
    end

    def monthly_stripe_price_id
      stripe_price_monthly_id&.call
    end

    def yearly_stripe_price_id
      stripe_price_yearly_id&.call
    end
  end
end
