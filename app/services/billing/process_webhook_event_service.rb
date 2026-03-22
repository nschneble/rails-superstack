module Billing
  class ProcessWebhookEventService < BaseService
    HANDLED_EVENTS = %w[
      checkout.session.completed
      customer.subscription.updated
      customer.subscription.deleted
    ].freeze

    def call(stripe_event_id:, event_type:, payload:)
      event_record = WebhookEvent.find_or_initialize_by(stripe_event_id:)

      if event_record.persisted? && !event_record.pending? && !event_record.failed?
        return ServiceResult.ok(event_record)
      end

      unless HANDLED_EVENTS.include?(event_type)
        event_record.assign_attributes(event_type:, payload:, status: :ignored)
        event_record.save!
        return ServiceResult.ok(event_record)
      end

      event_record.assign_attributes(event_type:, payload:, status: :processing)
      event_record.save!

      handle_event(event_type, payload, event_record)
    rescue ActiveRecord::RecordNotUnique
      ServiceResult.ok(WebhookEvent.find_by(stripe_event_id:))
    rescue => e
      event_record.update!(status: :failed, error_message: e.message)
      raise
    end

    private

    def handle_event(event_type, payload, event_record)
      case event_type
      when "checkout.session.completed"
        handle_checkout_completed(payload, event_record)
      when "customer.subscription.updated", "customer.subscription.deleted"
        handle_subscription_change(payload, event_record)
      end
    end

    def handle_checkout_completed(payload, event_record)
      session = payload.dig("data", "object")

      result = if session["mode"] == "subscription"
        handle_subscription_checkout(session)
      elsif session["mode"] == "payment"
        Demo::Themes::CompletePurchaseService.call(checkout_session_payload: session)
      else
        ServiceResult.ok(nil)
      end

      if result.success?
        event_record.update!(status: :processed)
        ServiceResult.ok(event_record)
      else
        event_record.update!(status: :failed, error_message: result.error.to_s)
        ServiceResult.fail(:processing_failed, result.error)
      end
    end

    def handle_subscription_checkout(session)
      stripe_subscription = stripe_client.v1.subscriptions.retrieve(session["subscription"])
      UpsertSubscriptionService.call(
        stripe_subscription:,
        customer_id: session["customer"]
      )
    end

    def handle_subscription_change(payload, event_record)
      sub_data = payload.dig("data", "object")
      stripe_subscription = stripe_client.v1.subscriptions.retrieve(sub_data["id"])

      result = UpsertSubscriptionService.call(
        stripe_subscription:,
        customer_id: sub_data["customer"]
      )

      if result.success?
        event_record.update!(status: :processed)
        ServiceResult.ok(event_record)
      else
        event_record.update!(status: :failed, error_message: result.error.to_s)
        ServiceResult.fail(:processing_failed, result.error)
      end
    end
  end
end
