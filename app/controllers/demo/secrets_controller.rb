  class Demo::SecretsController < ApplicationController
    layout "demo/moxie"

    # app/views/demo/secrets.html.erb
    def sssssh
      return if Flipper.enabled?(:secrets, current_user)

      raise ActionController::RoutingError,
        %(No route matches [#{request.request_method}] "#{request.path}")
    end
  end
