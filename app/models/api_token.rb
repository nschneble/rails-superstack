class ApiToken < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :token_digest, presence: true, uniqueness: true

  scope :active, -> {
    where(revoked_at: nil).
    where("expires_at IS NULL OR expires_at > ?", Time.current)
  }

  attr_reader :plaintext_token

  def self.issue!(user:, name:, expires_at: nil)
    token = new(user:, name:, expires_at:)
    token.generate_plaintext_token!
    token.save!
    token
  end

  def self.authenticate(plaintext_token)
    return if plaintext_token.blank?

    active.find_by(token_digest: digest(plaintext_token))
  end

  def self.digest(plaintext_token)
    Digest::SHA256.hexdigest(plaintext_token)
  end

  def active?
    revoked_at.nil? && (expires_at.nil? || expires_at.future?)
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  def mark_used!
    update_column(:last_used_at, Time.current)
  end

  def generate_plaintext_token!
    @plaintext_token = SecureRandom.hex(32)
    self.token_digest = self.class.digest(@plaintext_token)
  end
end
