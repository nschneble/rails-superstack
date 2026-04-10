# Provides shared redirect behavior for controllers initiating Stripe sessions

module Redirectable
  def redirect_to_stripe_url(result, fallback_path:, fallback_alert:)
    if result.success?
      redirect_to result.payload.url, allow_other_host: true
    else
      redirect_to fallback_path, alert: fallback_alert
    end
  end
end
