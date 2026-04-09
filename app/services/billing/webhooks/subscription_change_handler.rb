module Billing
  # Handles customer subscription webhooks by syncing the subscription
  class Webhooks::SubscriptionChangeHandler < BillingService
    def call(payload:)
      session = payload.dig("data", "object")

      stripe_subscription = stripe_client.v1.subscriptions.retrieve(session["id"])
      stripe_customer_id = session["customer"]

      UpsertSubscriptionService.call(stripe_subscription:, stripe_customer_id:)
    end
  end
end
