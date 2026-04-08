module Notifications
  # Aggregates all notifications
  module Notifiable
    extend ActiveSupport::Concern

    include FlashNotifiable
    include GlobalNotifiable
    include UserNotifiable

    included do
      helper_method :notifications
    end

    private

    def notifications
      @notifications ||= flash_notifications + user_notifications + global_notifications
    end
  end
end
