module SuperAdmin
  # SuperAdmin dashboard for Stripe subscriptions
  class SubscriptionDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id cancel_at current_period_end_at plan status stripe_customer_id stripe_subscription_id trial_ends_at user_id]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id cancel_at current_period_end_at plan status stripe_customer_id stripe_subscription_id trial_ends_at user_id]
    end

    # Attributes shown in the form
    def form_attributes
      %i[cancel_at current_period_end_at plan status stripe_customer_id stripe_subscription_id trial_ends_at user_id]
    end
  end
end
