# Adds subscription and plan helpers to models

module Subscribable
  extend ActiveSupport::Concern

  included do
    has_one :subscription, dependent: :destroy
  end

  def subscription
    super || Subscription.new
  end

  def stripe_customer_id
    subscription.stripe_customer_id
  end

  def stripe_subscription_id
    subscription.stripe_subscription_id
  end

  def subscription_plan
    subscription.plan
  end

  def active_subscription?
    subscription.active?
  end

  def pro_subscription?
    subscription.pro?
  end
end
