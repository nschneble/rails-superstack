module Billing
  class CreateCheckoutSessionService < BillingService
    FREE_TRIAL_DURATION = 7.days
    SECONDS_PER_DAY = 86400
    TRIAL_PERIOD_IN_DAYS = FREE_TRIAL_DURATION.to_i / SECONDS_PER_DAY

    def call(user:, price_id:, success_url:, cancel_url:)
      trial_period_days = eligible_for_trial?(user) ? TRIAL_PERIOD_IN_DAYS : nil

      customer = user.stripe_customer_id
      customer = create_customer(user) if customer.nil?

      session_params = {
        customer:,
        line_items: [ { price: price_id, quantity: 1 } ],
        mode: "subscription",
        success_url:,
        cancel_url:,
        allow_promotion_codes: true
      }

      session_params[:subscription_data] = { trial_period_days: } if trial_period_days
      session = stripe_client.v1.checkout.sessions.create(session_params)

      ServiceResult.ok(session)
    rescue Stripe::StripeError => error
      Rails.logger.error("[Billing] Checkout error: #{error.message}")
      ServiceResult.fail(:stripe_error, error.message)
    end

    private

    def eligible_for_trial?(user)
      subscription = user.subscription
      subscription.nil? || (subscription.incomplete? && subscription.stripe_subscription_id.nil?)
    end

    def create_customer(user)
      customer = stripe_client.v1.customers.create(email: user.email)
      subscription = user.build_subscription(stripe_customer_id: customer.id, plan: "free", status: :incomplete)
      subscription.save!
      customer.id
    end
  end
end
