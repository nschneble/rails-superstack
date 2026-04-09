# Base controller with auth, notifications, and search query setup

class ApplicationController < ActionController::Base
  include Authenticatable
  include Notifications::Notifiable
  include Pagy::Method
  include Rescuable

  before_action :set_search_query

  default_form_builder CustomFormBuilder
  allow_browser versions: :modern

  stale_when_importmap_changes

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied, User::NotAuthorized, with: :deny_access

  # app/views/application/root.html.erb
  def root; end

  private

  def set_search_query
    @query ||= params[:q].presence || "*"
  end
end
