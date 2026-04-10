module Notifications
  # Aggregates global notifications
  module GlobalNotifiable
    extend ActiveSupport::Concern

    GLOBAL_NOTIFICATION_TTL = 10.minutes

    private

    # :reek:FeatureEnvy — concern's purpose is to inspect the notification
    def global_notifications
      notification = NewGlobalNotificationNotifier.newest_first.first
      return [] if notification.blank? ||
                   notification.created_at < GLOBAL_NOTIFICATION_TTL.ago ||
                   global_notification_id == notification.id

      set_global_notification_id(notification.id)
      [ Notification.new(type: "info", message: notification.params[:message]) ]
    end

    def set_global_notification_id(value, expires: 1.year.from_now)
      cookies.signed[:global_notification_id] = { value:, expires: }
    end

    def global_notification_id
      cookies.signed[:global_notification_id].to_i
    end
  end
end
