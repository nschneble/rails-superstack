module Billing
  class CreatePortalSessionService < BaseService
    def call(user:, return_url:)
      customer_id = user.stripe_customer_id
      return ServiceResult.fail(:no_customer) if customer_id.blank?

      session = stripe_client.v1.billing_portal.sessions.create(
        customer: customer_id,
        return_url:
      )

      ServiceResult.ok(session)
    rescue Stripe::StripeError => error
      Rails.logger.error("[Billing] Portal error: #{error.message}")
      ServiceResult.fail(:stripe_error, error.message)
    end
  end
end
