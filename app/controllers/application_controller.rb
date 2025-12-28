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

  def home; end

  private

  def deny_access
    head :forbidden
  end

  def show_record_errors(exception)
    redirect_back_or_to root_path, alert: exception.record.errors.full_messages.to_sentence
  end
end
