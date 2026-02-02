module Authentication
  extend ActiveSupport::Concern

  include Passwordless::ControllerHelpers

  included do
    helper_method :current_user
  end

  private

  def current_user
    @current_user ||= authenticate_by_session(User)
  end

  def authenticate_user!
    return if current_user
    save_passwordless_redirect_location!(User)
    redirect_to passwordless_sign_in_path, alert: t("authentication.login_required")
  end

  def passwordless_sign_in_path
    Rails.application.routes.url_helpers.auth_sign_in_path
  end
end
