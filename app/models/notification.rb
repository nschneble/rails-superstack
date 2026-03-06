class Notification < ApplicationRecord
  include Tableless

  TWITTER_STYLEZ = 140.freeze
  TYPES = %w[alert info notice].freeze

  self.inheritance_column = :_type_disabled

  attribute :message, :string
  attribute :type, :string

  validates :message, presence: true, length: { maximum: TWITTER_STYLEZ }
  validates :type, inclusion: { in: TYPES,
    message: I18n.t("validations.notifications.bad_type") }
end
