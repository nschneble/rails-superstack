# Routes incoming Stripe webhook events to the appropriate handlers

class Billing::ProcessWebhookEventService < BaseService
  HANDLERS = {
    "checkout.session.completed"    => Billing::Webhooks::CheckoutCompleteHandler,
    "customer.subscription.updated" => Billing::Webhooks::SubscriptionChangeHandler,
    "customer.subscription.deleted" => Billing::Webhooks::SubscriptionChangeHandler
  }.freeze

  # :reek:DuplicateMethodCall — ServiceResult.ok(event) appears in 3 distinct early-return paths; single return point would reduce clarity
  # :reek:TooManyStatements — 8 steps: find/check event, resolve handler, assign attrs, save, guard, dispatch; each is a required webhook processing step
  def call(stripe_event_id:, event_type:, payload:)
    event = WebhookEvent.find_or_initialize_by(stripe_event_id:)
    return ServiceResult.ok(event) if event.processed?

    handler = HANDLERS[event_type]
    status = handler ? :processing : :ignored

    event.assign_attributes(event_type:, payload:, status:)
    event.save!

    return ServiceResult.ok(event) unless handler.present?

    dispatch_handler(event, handler, payload)
  rescue ActiveRecord::RecordNotUnique
    ServiceResult.ok(WebhookEvent.find_by(stripe_event_id:))
  rescue => error
    event.update!(status: :failed, error_message: error.message)
    raise
  end

  private

  # :reek:TooManyStatements — call handler, branch on result, update event status either way; handler dispatch is inherently 2-path
  def dispatch_handler(event, handler, payload)
    result = handler.call(payload:)
    if result.success?
      event.update!(status: :processed)
      ServiceResult.ok(event)
    else
      error = result.error
      event.update!(status: :failed, error_message: error.to_s)
      ServiceResult.fail(:processing_failed, error)
    end
  end
end
