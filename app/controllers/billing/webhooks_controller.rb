module Billing
  # Receives and validates incoming Stripe webhook events
  class WebhooksController < ActionController::Base
    skip_forgery_protection

    def create
      process_webhook_event(
        Stripe::Webhook.construct_event(
          payload,
          sig_header,
          Figaro.env.stripe_signing_secret
        )
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError => error
      Rails.logger.warn(self.class) { "Signature verification failed: #{error.message}" }
      head :bad_request
    end

    private

    def payload
      request.body.read
    end

    def sig_header
      request.env["HTTP_STRIPE_SIGNATURE"]
    end

    def process_webhook_event(event)
      stripe_event_id = event.id
      result = ProcessWebhookEventService.call(
        stripe_event_id:,
        event_type: event.type,
        payload: event.as_json
      )

      if result.success?
        head :ok
      else
        Rails.logger.error(self.class) { "Processing failed for #{stripe_event_id}: #{result.error}" }
        head :unprocessable_content
      end
    end
  end
end
