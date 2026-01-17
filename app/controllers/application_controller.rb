class ApplicationController < ActionController::Base
  include Authentication

  rescue_from User::NotAuthorized, with: :deny_access
  rescue_from ActiveRecord::RecordInvalid, with: :show_record_errors

  default_form_builder CustomFormBuilder
  allow_browser versions: :modern

  stale_when_importmap_changes

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  def terminal; end
  def welcome;  end

  private

  def deny_access
    redirect_to root_path, alert: t("super_admin.flash.access_denied")
  end

  def show_record_errors(exception)
    redirect_back_or_to root_path, alert: exception.record.errors.full_messages.to_sentence
  end
end
