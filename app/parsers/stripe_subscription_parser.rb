# Parses a Stripe subscription object

class StripeSubscriptionParser < BaseParser
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
    plans = {
      Figaro.env.stripe_price_pro_monthly => "pro_monthly",
      Figaro.env.stripe_price_pro_yearly  => "pro_yearly"
    }.fetch(price_id, "free")
  end

  def format_timestamp(timestamp)
    Time.zone.at(timestamp)
  rescue TypeError
    nil
  end
end
