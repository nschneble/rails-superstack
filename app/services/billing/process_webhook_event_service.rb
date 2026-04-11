# Routes incoming Stripe webhook events to the appropriate handlers

class Billing::ProcessWebhookEventService < BaseService
  HANDLERS = {
    "checkout.session.completed"    => Billing::Webhooks::CheckoutCompleteHandler,
    "customer.subscription.updated" => Billing::Webhooks::SubscriptionChangeHandler,
    "customer.subscription.deleted" => Billing::Webhooks::SubscriptionChangeHandler
  }.freeze

  def call(stripe_event_id:, event_type:, payload:)
    event = WebhookEvent.find_or_initialize_by(stripe_event_id:)
    process_event(event, event_type:, payload:) unless event.processed?

    ServiceResult.ok(event)
  rescue ActiveRecord::RecordNotUnique
    ServiceResult.ok(WebhookEvent.find_by(stripe_event_id:))
  rescue ServiceError => error
    event.update!(status: :failed, error_message: error.message)
    ServiceResult.fail(event.error_message)
  end

  private

  def process_event(event, event_type:, payload:)
    handler = HANDLERS[event_type]
    status = handler ? :processing : :ignored

    event.assign_attributes(event_type:, payload:, status:)
    event.save!

    dispatch_to_handler(event, handler:, payload:) if handler.present?
  end

  def dispatch_to_handler(event, handler:, payload:)
    result = handler.call(payload:)
    raise ServiceError, result.error if result.failure?

    event.update!(status: :processed)
  end
end
