class NotificationsController < AuthenticatedController
  # app/views/notifications/index.html.erb
  def index; end

  def create
    message = params.dig(:global_notification, :message).to_s.strip
    result = GlobalNotifications::BroadcastService.call(message:, actor: current_user)

    if result.success?
      redirect_to notifications_path, notice: t("notifications.status.success")
    else
      flash.now.alert = t("notifications.status.#{result.error}")
      render :index, status: :unprocessable_entity
    end
  end
end
