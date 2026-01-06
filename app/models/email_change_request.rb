class EmailChangeRequest < ApplicationRecord
  belongs_to :user

  normalizes :new_email, with: EmailNormalizer

  validates :new_email, presence: true, uniqueness: true, email: true
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true, comparison: { greater_than: Time.current }

  before_validation :ensure_token, on: :create
  before_validation :set_expiry, on: :create

  scope :active, -> { where("expires_at > ?", Time.current) }

  def expired?
    expires_at <= Time.current
  end

  private

  def ensure_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end

  def set_expiry
    self.expires_at ||= 10.minutes.from_now
  end
end
