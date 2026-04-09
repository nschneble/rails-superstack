module Demo
  # Base controller for demo pages that require authentication
  class DemoAuthenticatedController < DemoApplicationController
    before_action :authenticate_user!
  end
end
