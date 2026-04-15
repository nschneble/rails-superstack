# Displays the notifications page and broadcasts global notifications

class NotificationsController < AuthenticatedController
  # app/views/notifications/index.html.erb
  def index; end

  def create
    message = params.dig(:global_notification, :message).to_s.strip
    result = Notifications::BroadcastService.call(message:, actor: current_user)

    if result.success?
      event = NewGlobalNotificationNotifier.newest_first.first
      set_global_notification_id(event.id) if event
      redirect_to notifications_path, notice: t("notifications.status.success")
    else
      flash.now.alert = t("notifications.status.#{result.error}")
      render :index, status: :unprocessable_content
    end
  end
end
