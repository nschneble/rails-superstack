# SuperAdmin dashboard for Stripe subscriptions

class SuperAdmin::SubscriptionDashboard < SuperAdmin::BaseDashboard
  resource Subscription

  collection_attributes :id, :cancel_at, :current_period_end_at, :plan, :status, :stripe_customer_id, :stripe_subscription_id, :trial_ends_at, :user_id
  show_attributes :id, :cancel_at, :current_period_end_at, :plan, :status, :stripe_customer_id, :stripe_subscription_id, :trial_ends_at, :user_id
  form_attributes :cancel_at, :current_period_end_at, :plan, :status, :stripe_customer_id, :stripe_subscription_id, :trial_ends_at, :user_id
end
