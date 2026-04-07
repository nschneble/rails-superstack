# Records incoming Stripe webhook events and tracks their processing status

class WebhookEvent < ApplicationRecord
  enum :status, {
    pending: 0,
    processing: 1,
    processed: 2,
    failed: 3,
    ignored: 4
  }

  validates :stripe_event_id, presence: true, uniqueness: true
  validates :event_type, presence: true
  validates :payload, presence: true

  def processed?
    persisted? && !pending? && !failed?
  end
end
