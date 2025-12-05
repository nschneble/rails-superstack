class ApplicationController < ActionController::Base
  include Authentication

  default_form_builder CustomFormBuilder
  allow_browser versions: :modern

  stale_when_importmap_changes

  def home; end
end
