# Syncs a Stripe subscription object into the local Subscription record

class Billing::UpsertSubscriptionService < BaseService
  def call(stripe_subscription:, stripe_customer_id:)
    user = Subscription.find_by(stripe_customer_id:)&.user
    return ServiceResult.fail(:user_not_found) unless user

    subscription = user.subscription || user.build_subscription
    subscription.update!(
      stripe_subscription_id: stripe_subscription.id,
      plan:                   resolve_plan(stripe_subscription.items.data.first&.price&.id),
      status:                 stripe_subscription.status,
      cancel_at:              time_at(stripe_subscription["cancel_at"]),
      current_period_end_at:  time_at(stripe_subscription["current_period_end"]),
      trial_ends_at:          time_at(stripe_subscription["trial_end"])
    )

    ServiceResult.ok(subscription)
  end

  private

  def resolve_plan(price_id)
    case price_id
    when Figaro.env.stripe_price_pro_monthly then "pro_monthly"
    when Figaro.env.stripe_price_pro_yearly then "pro_yearly"
    else "free"
    end
  end

  def time_at(time)
    time ? Time.zone.at(time) : nil
  end
end
