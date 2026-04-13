# Provides handlers for common error scenarios

module Rescuable
  extend ActiveSupport::Concern

  included do
    helper_method :deny_access, :not_found
  end

  private

  def deny_access(exception)
    reset_passwordless_redirect_location!(User)
    redirect_back_or_to root_path, alert: exception.message
  end

  def not_found
    head :not_found
  end
end
