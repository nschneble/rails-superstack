module Billing
  # Receives and validates incoming Stripe webhook events
  class WebhooksController < ActionController::Base
    skip_forgery_protection

    # :reek:TooManyStatements — Stripe webhook validation requires: read body, extract sig, verify signature, extract event, call service, respond
    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      logger = Rails.logger

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, Figaro.env.stripe_signing_secret)
      rescue JSON::ParserError, Stripe::SignatureVerificationError => error
        logger.warn("[Billing::Webhooks] Signature verification failed: #{error.message}")
        return head :bad_request
      end

      event_id = event.id
      result = ProcessWebhookEventService.call(
        stripe_event_id: event_id,
        event_type: event.type,
        payload: event.as_json
      )

      respond_to_webhook_result(result, event_id)
    end

    private

    def respond_to_webhook_result(result, event_id)
      if result.success?
        head :ok
      else
        Rails.logger.error("[Billing::Webhooks] Processing failed for #{event_id}: #{result.error}")
        head :unprocessable_entity
      end
    end
  end
end
