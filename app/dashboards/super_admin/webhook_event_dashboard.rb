module SuperAdmin
  # SuperAdmin dashboard for Stripe webhook events
  class WebhookEventDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id error_message event_type payload status stripe_event_id]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id error_message event_type payload status stripe_event_id]
    end

    # Attributes shown in the form
    def form_attributes
      %i[error_message event_type payload status stripe_event_id]
    end
  end
end
