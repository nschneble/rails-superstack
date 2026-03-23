module Demo
  module Themes
    class CompletePurchaseService < BaseService
      def call(checkout_session_payload:)
        session_id = checkout_session_payload.dig("id")
        payment_intent_id = checkout_session_payload.dig("payment_intent")

        purchase = ThemePurchase.find_by(stripe_checkout_session_id: session_id)
        return ServiceResult.fail(:purchase_not_found) unless purchase

        purchase.update!(status: :completed, stripe_payment_intent_id: payment_intent_id)
        ServiceResult.ok(purchase)
      rescue ActiveRecord::RecordInvalid => error
        Rails.logger.error("[Demo::Themes] Failed to complete purchase: #{error.message}")
        ServiceResult.fail(:record_invalid, error.message)
      end
    end
  end
end
