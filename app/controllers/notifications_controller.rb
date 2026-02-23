class NotificationsController < AuthenticatedController
  layout "demo/moxie"

  # app/views/notifications/index.html.erb
  def index; end

  def create
    message = params.dig(:global_alert, :message).to_s.strip

    if message.blank?
      flash.now.alert = t("notifications.failure.blank")
      render :index, status: :unprocessable_entity and return
    end

    GlobalAlertNotifier.with(message:, actor: current_user).deliver([])
    redirect_to notifications_path, notice: t("notifications.success.sent")
  end
end
