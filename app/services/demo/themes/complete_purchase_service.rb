module Demo::Themes
  # Marks a pending theme purchase as complete after a successful payment
  class CompletePurchaseService < BaseService
    # :reek:TooManyStatements — find purchase, guard missing, update status, return result; plus rescue handling
    def call(session:)
      purchase = ThemePurchase.find_by(stripe_checkout_session_id: session.dig("id"))
      return ServiceResult.fail(:purchase_not_found) unless purchase

      purchase.update!(status: :completed, stripe_payment_intent_id: session.dig("payment_intent"))
      ServiceResult.ok(purchase)
    rescue ActiveRecord::RecordInvalid => error
      log_error_and_fail(:record_invalid, "Failed to complete purchase: #{error.message}")
    end
  end
end
