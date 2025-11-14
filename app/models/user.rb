class User < ApplicationRecord
  normalizes :email, with: EmailNormalizer

  validates :email, presence: true, uniqueness: true, email: true

  passwordless_with :email
end
