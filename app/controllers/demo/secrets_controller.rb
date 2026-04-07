module Demo
  # Gated page that's only visible when the `secrets` Flipper flag is enabled
  class SecretsController < DemoApplicationController
    # app/views/demo/secrets.html.erb
    def sssh
      return if Flipper.enabled?(:secrets, current_user)

      raise ActionController::RoutingError,
      %(No route matches [#{request.request_method}] "#{request.path}")
    end
  end
end
