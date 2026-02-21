class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method

  before_action :set_search_query
  before_action :set_notification_toasts

  rescue_from User::NotAuthorized, with: :deny_access

  default_form_builder CustomFormBuilder
  allow_browser versions: :modern

  stale_when_importmap_changes

  rescue_from CanCan::AccessDenied do |exception|
    redirect_back fallback_location: root_path, alert: exception.message
  end

  # app/views/application/root.html.erb
  def root
    # the root path route
  end

  private

  def set_search_query
    @query ||= params[:q].presence || "*"
  end

  def set_notification_toasts
    @toast_notifications = []

    if current_user
      unread_notifications = current_user.notifications.unread.newest_first.limit(3)
      @toast_notifications = unread_notifications.to_a
      unread_notifications.mark_as_read if @toast_notifications.any?
    end

    latest_system_notification = SystemNotificationNotifier.newest_first.first
    return unless latest_system_notification
    return if cookies.signed[:last_system_notification_id].to_i == latest_system_notification.id

    @system_notification_toast = latest_system_notification.params[:message]
    cookies.signed[:last_system_notification_id] = {
      value: latest_system_notification.id,
      expires: 1.year.from_now
    }
  end

  def deny_access
    redirect_back fallback_location: root_path, alert: t("super_admin.flash.access_denied")
  end
end
