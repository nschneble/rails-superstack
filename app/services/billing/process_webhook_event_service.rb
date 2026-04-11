# Routes incoming Stripe webhook events to the appropriate handlers

class Billing::ProcessWebhookEventService < BaseService
  HANDLERS = {
    "checkout.session.completed"    => Billing::Webhooks::CheckoutCompleteHandler,
    "customer.subscription.updated" => Billing::Webhooks::SubscriptionChangeHandler,
    "customer.subscription.deleted" => Billing::Webhooks::SubscriptionChangeHandler
  }.freeze

  def call(stripe_event_id:, event_type:, payload:)
    @event = WebhookEvent.find_or_initialize_by(stripe_event_id:)

    unless @event.processed?
      @handler = HANDLERS[event_type]

      update_event(event_type:, payload:)
      dispatch_to_handler(payload:) if @handler.present?
    end

    ServiceResult.ok(@event)
  rescue ActiveRecord::RecordNotUnique
    ServiceResult.ok(WebhookEvent.find_by(stripe_event_id:))
  rescue RuntimeError, ServiceError => error
    error_message = error.message
    @event.update!(status: :failed, error_message:)

    if error.is_a? RuntimeError
      raise
    else
      ServiceResult.fail(error_message)
    end
  end

  private

  def update_event(event_type:, payload:)
    status = @handler ? :processing : :ignored

    @event.assign_attributes(event_type:, payload:, status:)
    @event.save!
  end

  def dispatch_to_handler(payload:)
    result = @handler.call(payload:)
    raise ServiceError, result.error if result.failure?

    @event.update!(status: :processed)
  end
end
