module Demo
  module Themes
    class CreateCheckoutSessionService < BaseService
      def call(user:, theme_key:, success_url:, cancel_url:)
        theme = Demo::ThemePurchase::THEMES[theme_key]
        return ServiceResult.fail(:invalid_theme) unless theme

        if Demo::ThemePurchase.exists?(user:, theme_key:, status: :completed)
          return ServiceResult.fail(:already_purchased)
        end

        purchase = Demo::ThemePurchase.create!(user:, theme_key:, status: :pending)

        session = Stripe::Checkout::Session.create(
          customer_email: user.email,
          payment_method_types: [ "card" ],
          line_items: [ {
            price_data: {
              currency: "usd",
              unit_amount: theme[:price_cents],
              product_data: { name: theme[:name] }
            },
            quantity: 1
          } ],
          mode: "payment",
          success_url:,
          cancel_url:,
          metadata: { demo_theme_purchase_id: purchase.id }
        )

        purchase.update!(stripe_checkout_session_id: session.id)
        ServiceResult.ok(session)
      rescue Stripe::StripeError => e
        purchase&.update!(status: :failed)
        Rails.logger.error("[Demo::Themes] Checkout error: #{e.message}")
        ServiceResult.fail(:stripe_error, e.message)
      end
    end
  end
end
