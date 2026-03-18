class ApplicationController < ActionController::Base
  include Authenticatable
  include Notifiable
  include Pagy::Method

  before_action :set_search_query

  default_form_builder CustomFormBuilder
  allow_browser versions: :modern

  stale_when_importmap_changes

  rescue_from ActiveRecord::RecordNotFound,
              CanCan::AccessDenied,
              User::NotAuthorized, with: :deny_access

  # app/views/application/root.html.erb
  def root; end

  private

  def set_search_query
    @query ||= params[:q].presence || "*"
  end

  def deny_access(exception)
    alert = exception.message.presence || t("super_admin.flash.access_denied")
    redirect_back fallback_location: root_path, alert:
  end
end
