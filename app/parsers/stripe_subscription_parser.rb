# Parses a Stripe subscription object

class StripeSubscriptionParser < BaseParser
  class UnknownPriceError < StandardError; end

  def call(value)
    {
      stripe_subscription_id: value.id,
      plan: resolve_plan(value.items.data.first&.price&.id),
      status: value.status,
      cancel_at: format_timestamp(value["cancel_at"]),
      current_period_end_at: format_timestamp(value["current_period_end"]),
      trial_ends_at: format_timestamp(value["trial_end"])
    }
  end

  private

  def resolve_plan(price_id)
    return "free" if price_id.blank?

    {
      Figaro.env.stripe_price_pro_monthly => "pro_monthly",
      Figaro.env.stripe_price_pro_yearly  => "pro_yearly"
    }.fetch(price_id)
  rescue KeyError
    raise UnknownPriceError, "Unknown Stripe price id: #{price_id}"
  end

  def format_timestamp(timestamp)
    Time.zone.at(timestamp)
  rescue TypeError
    nil
  end
end
