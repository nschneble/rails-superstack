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

    # :reek:LongParameterList — Data.define value object; all fields are required data members
    def initialize(
      description: "",
      price_monthly_cents: 0,
      price_yearly_cents: 0,
      stripe_price_monthly_id: nil,
      stripe_price_yearly_id: nil,
      features: [],
      **args)
      super(
        **args,
        description:,
        price_monthly_cents:,
        price_yearly_cents:,
        stripe_price_monthly_id:,
        stripe_price_yearly_id:,
        features:
      )
    end

    def free?
      price_monthly_cents.zero? && price_yearly_cents.zero?
    end

    # :reek:ControlParameter — legitimate term-based dispatch; the two cases are fundamentally different lookups
    def stripe_price_id(term)
      case term
      when :monthly then stripe_price_monthly_id&.call
      when :yearly then stripe_price_yearly_id&.call
      else nil
      end
    end
  end
end
