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

  def require_user!
    return if current_user
    save_passwordless_redirect_location!(User)
    redirect_to root_path, alert: "You must be logged in"
  end
end
