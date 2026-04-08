# Provides authentication helpers for controllers

module Authenticatable
  extend ActiveSupport::Concern

  include Passwordless::ControllerHelpers

  included do
    helper_method :current_user
  end

  private

  def current_user
    @current_user ||= authenticate_by_session(User) || authenticate_by_token(bearer_token)
  end

  def authenticate_user!
    return if current_user

    save_passwordless_redirect_location!(User) if navigable_request?
    redirect_to passwordless_sign_in_path, alert: t("authentication.login_required")
  end

  def navigable_request?
    request.get? && request.format.html? && !turbo_frame_request?
  end

  def authenticate_by_token(token)
    return if token.blank?

    ApiToken.authenticate(token)&.tap(&:mark_used)&.user
  end

  def bearer_token
    header = request.authorization.to_s
    scheme, token = header.split(" ", 2)
    return unless scheme&.casecmp("Bearer")&.zero?

    token
  end

  def passwordless_sign_in_path
    Rails.application.routes.url_helpers.auth_sign_in_path
  end
end
