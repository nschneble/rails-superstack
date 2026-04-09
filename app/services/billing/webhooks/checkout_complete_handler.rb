module Billing
  # Handles checkout complete webhooks by upserting the resulting subscription
  class Webhooks::CheckoutCompleteHandler < BillingService
    # :reek:TooManyStatements — extract session, get mode, case-dispatch to handler; inherently multi-step webhook routing
    def call(payload:)
      session = payload.dig("data", "object")

      mode = session["mode"]
      case mode
      when "subscription" then handle_subscription_checkout(session)
      else
        handler = self.class.handlers[mode]
        handler ? handler.call(session:) : ServiceResult.ok(nil)
      end
    end

    private

    def handle_subscription_checkout(session)
      stripe_subscription = stripe_client.v1.subscriptions.retrieve(session["subscription"])
      stripe_customer_id = session["customer"]

      UpsertSubscriptionService.call(stripe_subscription:, stripe_customer_id:)
    end

    class << self
      def handlers
        @handlers ||= {}
      end

      def register(mode, handler)
        handlers[mode] = handler
      end
    end
  end
end
