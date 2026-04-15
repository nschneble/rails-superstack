# SuperAdmin dashboard for Stripe webhook events

class SuperAdmin::WebhookEventDashboard < SuperAdmin::BaseDashboard
  resource WebhookEvent

  collection_attributes :id, :error_message, :event_type, :payload, :status, :stripe_event_id
  show_attributes :id, :error_message, :event_type, :payload, :status, :stripe_event_id
  form_attributes :error_message, :event_type, :payload, :status, :stripe_event_id
end
