class Notification < ApplicationRecord
  include Tableless

  TYPES = %w[alert info notice].freeze

  self.inheritance_column = :_type_disabled

  attribute :message, :string
  attribute :type, :string

  validates :message, presence: true, length: { maximum: 140 }
  validates :type, inclusion: { in: TYPES,
    message: "%{value} is not a valid notification type" }
end
