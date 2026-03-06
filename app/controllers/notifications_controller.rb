class NotificationsController < AuthenticatedController
  # app/views/notifications/index.html.erb
  def index; end

  def create
    message = params.dig(:global_notification, :message).to_s.strip

    if message.blank?
      flash.now.alert = t("notifications.status.failure")
      render :index, status: :unprocessable_entity and return
    end

    NewGlobalNotificationNotifier.with(message:, actor: current_user).deliver([])
    redirect_to notifications_path, notice: t("notifications.status.success")
  end
end
