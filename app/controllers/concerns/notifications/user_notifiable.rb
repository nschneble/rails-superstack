module Notifications
  # Aggregates user notifications
  module UserNotifiable
    extend ActiveSupport::Concern

    private

    def user_notifications
      return [] unless current_user

      unread = current_user.notifications.unread.newest_first.limit(3).load
      unread.mark_as_read if unread.any?
      unread.map { Notification.new(type: "info", message: _1.message) }
    end
  end
end
