# Adds subscription and plan helpers to models

module Subscribable
  extend ActiveSupport::Concern

  included do
    has_one :subscription, dependent: :destroy
    delegate :stripe_customer_id, :stripe_subscription_id, to: :subscription, allow_nil: true
    delegate :plan, to: :subscription, prefix: true, allow_nil: true
  end

  def subscription
    super || Subscription.new
  end

  def active_subscription?
    subscription.active?
  end

  def pro_subscription?
    subscription.pro?
  end
end
