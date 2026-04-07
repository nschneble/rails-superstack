# Represents a user's Stripe subscription with status, plan, and billing period

class Subscription < ApplicationRecord
  belongs_to :user

  enum :status, {
    incomplete: 0,
    incomplete_expired: 1,
    trialing: 2,
    active: 3,
    past_due: 4,
    canceled: 5,
    unpaid: 6,
    paused: 7
  }

  FREE_PLANS = %w[free].freeze
  PRO_PLANS = %w[pro_monthly pro_yearly].freeze
  PLANS = (FREE_PLANS + PRO_PLANS).freeze

  validates :stripe_customer_id, presence: true, uniqueness: true
  validates :stripe_subscription_id, presence: true, if: :pro?
  validates :plan, inclusion: { in: PLANS }

  def active?
    status.in?(%w[active trialing])
  end

  def on_trial?
    trialing? && trial_ends_at&.future?
  end

  def pro?
    PRO_PLANS.include?(plan)
  end
end
