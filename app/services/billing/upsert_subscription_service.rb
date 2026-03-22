module Billing
  class UpsertSubscriptionService < BaseService
    def call(stripe_subscription:, customer_id:)
      user = User.joins(:subscription).find_by(subscriptions: { stripe_customer_id: customer_id })
      return ServiceResult.fail(:user_not_found) unless user

      sub = user.subscription || user.build_subscription

      item = stripe_subscription.items.data.first

      sub.update!(
        stripe_subscription_id: stripe_subscription.id,
        plan: resolve_plan(item&.price&.id),
        status: stripe_subscription.status,
        cancel_at: stripe_subscription.cancel_at ? Time.at(stripe_subscription.cancel_at) : nil,
        current_period_end_at: stripe_subscription.current_period_end ? Time.at(stripe_subscription.current_period_end) : nil,
        trial_ends_at: stripe_subscription.trial_end ? Time.at(stripe_subscription.trial_end) : nil
      )

      ServiceResult.ok(sub)
    end

    private

    def resolve_plan(price_id)
      case price_id
      when Figaro.env.stripe_price_pro_monthly then "pro_monthly"
      when Figaro.env.stripe_price_pro_yearly then "pro_yearly"
      else "free"
      end
    end
  end
end
