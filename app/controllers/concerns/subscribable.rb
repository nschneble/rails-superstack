module Subscribable
  extend ActiveSupport::Concern

  included do
    helper_method :current_subscription, :current_free_subscription?, :current_pro_subscription?
  end

  private

  def current_subscription
    return nil unless current_user

    current_user.subscription
  end

  def current_free_subscription?
    return nil unless current_subscription

    current_subscription.free?
  end

  def current_pro_subscription?
    return nil unless current_subscription

    current_subscription.pro?
  end
end
