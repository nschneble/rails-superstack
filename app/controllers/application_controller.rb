class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method

  before_action :set_search_query

  rescue_from User::NotAuthorized, with: :deny_access

  default_form_builder CustomFormBuilder
  allow_browser versions: :modern
  helper_method :notifications

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

  def notifications
    @notifications ||= begin
      items = flash_notifications
      append_unread_user_notifications!(items)
      append_latest_global_alert_notification!(items)
      items
    end
  end

  def flash_notifications
    flash.filter_map do |type, message|
      next if message.blank?

      Notification.new(message:, type: normalize_notification_type(type))
    end
  end

  def append_unread_user_notifications!(items)
    return unless current_user

    unread_notifications = current_user.notifications.unread.newest_first.limit(3)
    items.concat(
      unread_notifications.map { Notification.new(message: _1.message, type: "notice") }
    )
    unread_notifications.mark_as_read if unread_notifications.any?
  end

  def append_latest_global_alert_notification!(items)
    latest_global_alert = GlobalAlertNotifier.newest_first.first
    return unless latest_global_alert
    return if cookies.signed[:last_system_notification_id].to_i == latest_global_alert.id

    items << Notification.new(message: latest_global_alert.params[:message], type: "notice")
    cookies.signed[:last_system_notification_id] = {
      value: latest_global_alert.id,
      expires: 1.year.from_now
    }
  end

  def normalize_notification_type(type)
    normalized_type = type.to_s.downcase
    return normalized_type if Notification::TYPES.include?(normalized_type)

    "notice"
  end

  def deny_access
    redirect_back fallback_location: root_path, alert: t("super_admin.flash.access_denied")
  end
end
