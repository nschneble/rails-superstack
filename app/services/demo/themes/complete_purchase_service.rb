module Demo::Themes
  # Marks a pending theme purchase as complete after a successful payment
  class CompletePurchaseService < BaseService
    def call(session:)
      stripe_checkout_session_id = session.dig("id")
      purchase = ThemePurchase.find_by(stripe_checkout_session_id:)

      return ServiceResult.fail(:purchase_not_found) unless purchase

      stripe_payment_intent_id = session.dig("payment_intent")
      purchase.update!(status: :completed, stripe_payment_intent_id:)

      ServiceResult.ok(purchase)
    rescue ActiveRecord::RecordInvalid => error
      Rails.logger.error("[Demo::Themes] Failed to complete purchase: #{error.message}")
      ServiceResult.fail(:record_invalid, error.message)
    end
  end
end
