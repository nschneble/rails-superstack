module Notifications
  # Aggregates user notifications
  module UserNotifiable
    extend ActiveSupport::Concern

    private

    # :reek:FeatureEnvy — operates on user's unread notifications; concern's purpose is to read and mark them
    def user_notifications
      return [] unless current_user

      unread = current_user.notifications.unread.newest_first.limit(3).load
      unread.mark_as_read if unread.any?
      unread.map { Notification.new(type: "info", message: _1.message) }
    end
  end
end
