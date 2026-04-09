module Billing
  # Receives and validates incoming Stripe webhook events
  class WebhooksController < ActionController::Base
    skip_forgery_protection

    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, Figaro.env.stripe_signing_secret)
      rescue JSON::ParserError, Stripe::SignatureVerificationError => error
        Rails.logger.warn("[Billing::Webhooks] Signature verification failed: #{error.message}")
        return head :bad_request
      end

      result = ProcessWebhookEventService.call(
        stripe_event_id: event.id,
        event_type: event.type,
        payload: event.as_json
      )

      if result.success?
        head :ok
      else
        Rails.logger.error("[Billing::Webhooks] Processing failed for #{event.id}: #{result.error}")
        head :unprocessable_entity
      end
    end
  end
end
