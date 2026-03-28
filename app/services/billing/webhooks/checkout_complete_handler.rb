module Billing
  class Webhooks::CheckoutCompleteHandler < BillingService
    def call(payload:)
      session = payload.dig("data", "object")

      case session["mode"]
      when "subscription"
        handle_subscription_checkout(session)
      when "payment"
        # FIXME: demo logic should not be present here
        Demo::Themes::CompletePurchaseService.call(session:)
      else
        ServiceResult.ok(nil)
      end
    end

    private

    def handle_subscription_checkout(session)
      stripe_subscription = stripe_client.v1.subscriptions.retrieve(session["subscription"])
      stripe_customer_id = session["customer"]

      UpsertSubscriptionService.call(stripe_subscription:, stripe_customer_id:)
    end
  end
end
