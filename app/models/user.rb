class User < ApplicationRecord
  class NotAuthorized < StandardError; end

  include Indexable
  include Typesense

  typesense enqueue: :index_async do
    attributes :email
    default_sorting_field "email"

    predefined_fields [
      {
        name: "email",
        type: "string",
        sort: true
      }
    ]
  end

  has_many :api_tokens, dependent: :destroy
  has_many :email_change_requests, dependent: :destroy

  normalizes        :email, with: EmailNormalizer
  validates         :email, presence: true, uniqueness: true, email: true
  passwordless_with :email

  enum :role, { user: 0, admin: 1 }

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
