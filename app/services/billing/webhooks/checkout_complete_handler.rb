module Billing
  # Handles checkout complete webhooks by upserting the resulting subscription
  class Webhooks::CheckoutCompleteHandler < BillingService
    def call(payload:)
      @session = payload.dig("data", "object")
      return handle_subscription_checkout if mode == "subscription"

      handle_purchase_checkout
    end

    private

    def handle_subscription_checkout
      UpsertSubscriptionService.call(
        stripe_subscription: stripe_client.v1.subscriptions.retrieve(@session["subscription"]),
        stripe_customer_id: @session["customer"]
      )
    end

    def handle_purchase_checkout
      handler = self.class.handlers[mode]
      handler ? handler.call(session: @session) : ServiceResult.ok(nil)
    end

    def mode
      @session["mode"]
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
