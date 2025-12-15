class User < ApplicationRecord
  normalizes :email, with: EmailNormalizer

  validates :email, presence: true, uniqueness: true, email: true

  passwordless_with :email

  def record_passwordless_login!(request)
    now = Time.current

    attrs = {
      last_login_at: now,
      last_login_ip: request.remote_ip,
      login_count:   login_count + 1
    }

    attrs[:email_confirmed_at] ||= now if email_confirmed_at.nil?

    update!(attrs)
  end

  def email_confirmed?
    email_confirmed_at.present?
  end
end
