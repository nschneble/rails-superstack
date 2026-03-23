module Billing
  class CreateCheckoutSessionService < BaseService
    def call(user:, price_id:, success_url:, cancel_url:)
      first_time = user.subscription.nil?
      customer_id = find_or_create_customer(user)

      trial_days = first_time ? 30 : nil

      session_params = {
        customer: customer_id,
        line_items: [ { price: price_id, quantity: 1 } ],
        mode: "subscription",
        success_url:,
        cancel_url:,
        allow_promotion_codes: true
      }

      session_params[:subscription_data] = { trial_period_days: trial_days } if trial_days

      session = stripe_client.v1.checkout.sessions.create(session_params)
      ServiceResult.ok(session)
    rescue Stripe::StripeError => error
      Rails.logger.error("[Billing] Checkout error: #{error.message}")
      ServiceResult.fail(:stripe_error, error.message)
    end

    private

    def find_or_create_customer(user)
      return user.stripe_customer_id if user.stripe_customer_id.present?

      customer = stripe_client.v1.customers.create(email: user.email)
      sub = user.build_subscription(stripe_customer_id: customer.id, plan: "free", status: :incomplete)
      sub.save!
      customer.id
    end
  end
end
