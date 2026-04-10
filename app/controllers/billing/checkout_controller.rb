module Billing
  # Creates a Stripe checkout session and renders the post-payment success page
  class CheckoutController < AuthenticatedController
    include Redirectable

    def create
      price_id = params[:price_id]
      return redirect_to billing_plans_path, alert: t("billing.checkout.invalid_plan") if price_id.blank?

      result = CreateCheckoutSessionService.call(
        user: current_user,
        price_id:,
        success_url: billing_checkout_success_url(session_id: "{CHECKOUT_SESSION_ID}"),
        cancel_url: billing_plans_url
      )

      redirect_to_stripe_url(
        result,
        fallback_path: billing_plans_path,
        fallback_alert: t("billing.checkout.error")
      )
    end

    # app/views/billing/checkout/success.html.erb
    def success; end
  end
end
