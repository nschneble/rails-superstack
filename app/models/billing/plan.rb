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

    def free?
      key == "free"
    end

    alias_attribute :paid?, :pro?
    def pro?
      key == "pro"
    end

    def monthly_price_display
      return "Free" if price_monthly_cents.zero?
      format("$%g/month", price_monthly_cents / 100.0)
    end

    def yearly_price_display
      return "Free" if price_yearly_cents.zero?
      format("$%g/year", price_yearly_cents / 100.0)
    end

    def monthly_stripe_price_id
      stripe_price_monthly_id&.call
    end

    def yearly_stripe_price_id
      stripe_price_yearly_id&.call
    end
  end

  Plan::FREE = Plan.new(
    key: "free",
    name: "Free",
    description: "Everything you need to get started",
    price_monthly_cents: 0,
    price_yearly_cents: 0,
    stripe_price_monthly_id: nil,
    stripe_price_yearly_id: nil,
    features: [
      "Up to 3 projects",
      "API access",
      "Community support"
    ]
  )

  Plan::PRO = Plan.new(
    key: "pro",
    name: "Pro",
    description: "For teams that need more power",
    price_monthly_cents: 1200,
    price_yearly_cents: 9600,
    stripe_price_monthly_id: -> { Figaro.env.stripe_price_pro_monthly },
    stripe_price_yearly_id: -> { Figaro.env.stripe_price_pro_yearly },
    features: [
      "Unlimited projects",
      "Priority support",
      "Advanced analytics",
      "Custom integrations",
      "Team collaboration"
    ]
  )
end
