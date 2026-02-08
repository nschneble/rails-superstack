class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method

  before_action :set_search_query

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

  def deny_access
    redirect_back fallback_location: root_path, alert: t("super_admin.flash.access_denied")
  end
end
