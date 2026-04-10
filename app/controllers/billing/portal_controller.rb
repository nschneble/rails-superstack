module Billing
  # Redirects authenticated users to the Stripe customer billing portal
  class PortalController < AuthenticatedController
    include Redirectable

    def create
      result = CreatePortalSessionService.call(
        user: current_user,
        return_url: settings_billing_url
      )

      redirect_to_stripe_url(
        result,
        fallback_path: settings_profile_path,
        fallback_alert: t("billing.portal.error")
      )
    end
  end
end
