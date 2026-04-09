module Demo::Themes
  # Creates a Stripe one-time checkout session for purchasing a demo theme
  # :reek:TooManyStatements — 7 sequential steps: validate theme, guard duplicates, create purchase, build session, update record, return
  class CreateCheckoutSessionService < Billing::BillingService
    # :reek:LongParameterList — 4 keyword args; all are required Stripe checkout context
    def call(user:, theme_key:, success_url:, cancel_url:)
      theme = Theme.find(theme_key)

      return ServiceResult.fail(:invalid_theme) unless theme
      return ServiceResult.fail(:already_purchased) if ThemePurchase.exists?(user:, theme_key:, status: :completed)

      purchase = ThemePurchase.create!(user:, theme_key:, status: :pending)
      session = stripe_client.v1.checkout.sessions.create(checkout_params(user, theme, purchase, success_url, cancel_url))

      purchase.update!(stripe_checkout_session_id: session.id)
      ServiceResult.ok(session)
    rescue Stripe::StripeError => error
      handle_stripe_error(error, purchase)
    end

    private

    def handle_stripe_error(error, purchase)
      message = error.message
      purchase&.update!(status: :failed)
      Rails.logger.error("[Demo::Themes] Checkout error: #{message}")
      ServiceResult.fail(:stripe_error, message)
    end

    # :reek:LongParameterList — all 5 args are required Stripe checkout inputs with no natural grouping
    def checkout_params(user, theme, purchase, success_url, cancel_url)
      {
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
      }
    end
  end
end
