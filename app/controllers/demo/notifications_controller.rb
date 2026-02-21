class Demo::NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  layout "demo/moxie"

  def new
  end

  def create
    message = params.dig(:system_notification, :message).to_s.strip

    if message.blank?
      flash.now.alert = "Message can't be blank"
      render :new, status: :unprocessable_entity
      return
    end

    SystemNotificationNotifier.with(message: message, actor: current_user).deliver([])
    redirect_to demo_system_notifications_path, notice: "System notification sent"
  end

  private

  def ensure_admin!
    raise User::NotAuthorized unless current_user&.admin?
  end
end
