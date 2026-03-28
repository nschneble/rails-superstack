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

  PLANS = %w[free pro_monthly pro_yearly].freeze

  validates :stripe_customer_id, presence: true, uniqueness: true
  validates :plan, inclusion: { in: PLANS }

  def active?
    status.in?(%w[active trialing])
  end

  def on_trial?
    trialing? && trial_ends_at&.future?
  end

  def free?
    !pro?
  end

  def pro?
    plan.in?(%w[pro_monthly pro_yearly])
  end
end
