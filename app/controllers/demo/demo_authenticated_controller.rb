module Demo
  class DemoAuthenticatedController < DemoApplicationController
    before_action :authenticate_user!
  end
end
