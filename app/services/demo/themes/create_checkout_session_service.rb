module Demo::Themes
  class CreateCheckoutSessionService < Billing::BillingService
    def call(user:, theme_key:, success_url:, cancel_url:)
      theme = ThemePurchase::THEMES[theme_key]

      return ServiceResult.fail(:invalid_theme) unless theme
      return ServiceResult.fail(:already_purchased) if ThemePurchase.exists?(user:, theme_key:, status: :completed)

      purchase = ThemePurchase.create!(user:, theme_key:, status: :pending)
      session = stripe_client.v1.checkout.sessions.create(
        customer_email: user.email,
        line_items: [ {
          price_data: {
            currency: "usd",
            unit_amount: theme.price_cents,
            product_data: { name: theme.name }
          },
          quantity: 1
        } ],
        mode: "payment",
        success_url:,
        cancel_url:,
        metadata: { theme_purchase_id: purchase.id }
      )

      purchase.update!(stripe_checkout_session_id: session.id)
      ServiceResult.ok(session)
    rescue Stripe::StripeError => error
      purchase&.update!(status: :failed)
      Rails.logger.error("[Demo::Themes] Checkout error: #{error.message}")
      ServiceResult.fail(:stripe_error, error.message)
    end
  end
end
