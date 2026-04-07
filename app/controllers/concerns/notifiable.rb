# Aggregates user and global notifications

module Notifiable
  extend ActiveSupport::Concern

  GLOBAL_NOTIFICATION_TTL = 10.minutes

  included do
    helper_method :notifications
  end

  private

  def notifications
    @notifications ||= flash_notifications + user_notifications + global_notifications
  end

  def flash_notifications
    flash.filter_map do |type, message|
      next if message.blank?
      Notification.new(type:, message:)
    end
  end

  def user_notifications
    return [] unless current_user

    unread = current_user.notifications.unread.newest_first.limit(3).load
    unread.mark_as_read if unread.any?
    unread.map { Notification.new(type: "info", message: _1.message) }
  end

  def global_notifications
    notification = NewGlobalNotificationNotifier.newest_first.first
    return [] if notification.blank?
    return [] if notification.created_at < GLOBAL_NOTIFICATION_TTL.ago

    return [] if cookies.signed[:global_notification_id].to_i == notification.id

    cookies.signed[:global_notification_id] = {
      value: notification.id,
      expires: 1.year.from_now
    }

    [ Notification.new(type: "info", message: notification.params[:message]) ]
  end
end
