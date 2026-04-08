module Notifications
  # Aggregates flash notifications
  module FlashNotifiable
    extend ActiveSupport::Concern

    private

    def flash_notifications
      flash.filter_map do |type, message|
        next if message.blank?
        Notification.new(type:, message:)
      end
    end
  end
end
