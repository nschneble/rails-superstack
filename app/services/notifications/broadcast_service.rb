module Notifications
  class BroadcastService < BaseService
    def call(message:, actor:)
      return ServiceResult.fail(:blank) if message.blank?
      return ServiceResult.fail(:too_long) if message.length > Notification::MAX_MESSAGE_LENGTH

      NewGlobalNotificationNotifier.with(message:, actor:).deliver([])

      ServiceResult.ok
    end
  end
end
