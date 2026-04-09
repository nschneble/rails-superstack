# Routes incoming Stripe webhook events to the appropriate handlers

class Billing::ProcessWebhookEventService < BaseService
  HANDLERS = {
    "checkout.session.completed"    => Billing::Webhooks::CheckoutCompleteHandler,
    "customer.subscription.updated" => Billing::Webhooks::SubscriptionChangeHandler,
    "customer.subscription.deleted" => Billing::Webhooks::SubscriptionChangeHandler
  }.freeze

  def call(stripe_event_id:, event_type:, payload:)
    event = WebhookEvent.find_or_initialize_by(stripe_event_id:)
    return ServiceResult.ok(event) if event.processed?

    handler = HANDLERS[event_type]
    status = handler ? :processing : :ignored

    event.assign_attributes(event_type:, payload:, status:)
    event.save!

    return ServiceResult.ok(event) unless handler.present?

    result = handler.call(payload:)
    if result.success?
      event.update!(status: :processed)
      ServiceResult.ok(event)
    else
      event.update!(status: :failed, error_message: result.error.to_s)
      ServiceResult.fail(:processing_failed, result.error)
    end
  rescue ActiveRecord::RecordNotUnique
    ServiceResult.ok(WebhookEvent.find_by(stripe_event_id:))
  rescue => error
    event.update!(status: :failed, error_message: error.message)
    raise
  end
end
