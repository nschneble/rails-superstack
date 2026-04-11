module Billing
  # Creates a Stripe customer portal session for subscription self-management
  class CreatePortalSessionService < BillingService
    def call(user:, return_url:)
      customer = user.stripe_customer_id
      return ServiceResult.fail(:no_customer) if customer.blank?

      create_session(customer:, return_url:)
    rescue Stripe::StripeError => error
      log_error_and_fail(:stripe_error, "Portal error: #{error.message}")
    end

    private

    def create_session(customer:, return_url:)
      session = stripe_client.v1.billing_portal.sessions.create(customer:, return_url:)
      ServiceResult.ok(session)
    end
  end
end
