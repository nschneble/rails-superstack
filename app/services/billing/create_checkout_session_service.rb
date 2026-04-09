module Billing
  # Creates a Stripe subscription checkout session with optional trial period
  class CreateCheckoutSessionService < BillingService
    FREE_TRIAL_DURATION = 7.days
    SECONDS_PER_DAY = 86400
    TRIAL_PERIOD_IN_DAYS = FREE_TRIAL_DURATION.to_i / SECONDS_PER_DAY

    # :reek:LongParameterList — 4 keyword args; all are required Stripe checkout parameters
    def call(user:, price_id:, success_url:, cancel_url:)
      session_params = {
        customer: stripe_customer_id(user),
        line_items: [ { price: price_id, quantity: 1 } ],
        mode: "subscription",
        subscription_data: trial_subscription_data(user),
        success_url:,
        cancel_url:,
        allow_promotion_codes: true
      }

      session = stripe_client.v1.checkout.sessions.create(session_params)
      ServiceResult.ok(session)
    rescue Stripe::StripeError => error
      log_error_and_fail(:stripe_error, "Checkout error: #{error.message}")
    end

    private

    def stripe_customer_id(user)
      user.stripe_customer_id.presence || create_customer(user)
    end

    def create_customer(user)
      customer = stripe_client.v1.customers.create(email: user.email)
      stripe_customer_id = customer.id

      subscription = user.build_subscription(stripe_customer_id:, plan: "free", status: :incomplete)
      subscription.save!

      stripe_customer_id
    end

    def trial_subscription_data(user)
      return unless eligible_for_trial?(user)

      { trial_period_days: TRIAL_PERIOD_IN_DAYS }
    end

    def eligible_for_trial?(user)
      subscription = user.subscription
      subscription.blank? || (subscription.incomplete? && subscription.stripe_subscription_id.blank?)
    end
  end
end
