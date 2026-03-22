module Billing
  class CheckoutController < AuthenticatedController
    def create
      price_id = params[:price_id]
      return redirect_to plans_path, alert: t("billing.checkout.invalid_plan") if price_id.blank?

      result = CreateCheckoutSessionService.call(
        user: current_user,
        price_id:,
        success_url: billing_checkout_success_url(session_id: "{CHECKOUT_SESSION_ID}"),
        cancel_url: plans_url
      )

      if result.success?
        redirect_to result.payload.url, allow_other_host: true
      else
        redirect_to plans_path, alert: t("billing.checkout.error")
      end
    end

    # app/views/billing/checkout/success.html.erb
    def success; end
  end
end
