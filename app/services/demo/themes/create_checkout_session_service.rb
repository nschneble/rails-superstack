module Demo::Themes
  # Creates a Stripe one-time checkout session for purchasing a demo theme
  class CreateCheckoutSessionService < Billing::BillingService
    def call(user:, theme_key:, urls:)
      check_theme_and_past_purchases(user:, theme_key:)
      ServiceResult.ok(create_session(user:, theme_key:, urls:))
    rescue Stripe::StripeError => stripe_error
      @purchase.update!(status: :failed)
      log_error_and_fail(:stripe_error, "Checkout error: #{stripe_error.message}")
    rescue ServiceError => error
      ServiceResult.fail(error.message)
    end

    private

    attr_accessor :theme, :purchase

    def check_theme_and_past_purchases(user:, theme_key:)
      @theme = Theme.find(theme_key)
      purchased = ThemePurchase.exists?(user:, theme_key:, status: :completed)

      raise ServiceError, "invalid_theme" unless theme.present?
      raise ServiceError, "already_purchased" if purchased
    end

    def create_session(user:, theme_key:, urls:)
      @purchase = ThemePurchase.create!(user:, theme_key:, status: :pending)
      session = stripe_client.v1.checkout.sessions.create(checkout_params(user.email, purchase.id, urls))

      @purchase.update!(stripe_checkout_session_id: session.id)
      session
    end

    def checkout_params(customer_email, theme_purchase_id, urls)
      {
        customer_email:,
        line_items: [ {
          price_data: {
            currency: "usd",
            unit_amount: theme.price_cents,
            product_data: { name: theme.name }
          },
          quantity: 1
        } ],
        mode: "payment",
        success_url: urls[:success],
        cancel_url: urls[:cancel],
        metadata: { theme_purchase_id: }
      }
    end
  end
end
