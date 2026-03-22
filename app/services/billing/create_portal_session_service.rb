module Billing
  class CreatePortalSessionService < BaseService
    def call(user:, return_url:)
      customer_id = user.stripe_customer_id
      return ServiceResult.fail(:no_customer) if customer_id.blank?

      session = Stripe::BillingPortal::Session.create(
        customer: customer_id,
        return_url:
      )

      ServiceResult.ok(session)
    rescue Stripe::StripeError => e
      Rails.logger.error("[Billing] Portal error: #{e.message}")
      ServiceResult.fail(:stripe_error, e.message)
    end
  end
end
