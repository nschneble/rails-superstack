# Throttles abuse-prone unauthenticated/low-cost endpoints: sign-in (which
# creates a User row and sends a magic-link email per request), email-change
# confirmation, and the GraphQL endpoint.
#
# Rack::Attack itself is required early, in config/application.rb, not here
# -- see the comment there for why.
class Rack::Attack
  # Dedicated store so throttle counts aren't tied to the app's cache
  # eviction policy. Production/development use solid_cache/memory_store for
  # app caching; test uses :null_store, which would silently make every
  # throttle here a no-op if it shared Rails.cache.
  self.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle("sign_in/ip", limit: 5, period: 20) do |req|
    req.ip if req.path == "/sign_in" && req.post?
  end

  throttle("sign_in/email", limit: 5, period: 60) do |req|
    if req.path == "/sign_in" && req.post?
      EmailNormalizer.call(req.params.dig("passwordless", "email")).presence
    end
  end

  throttle("email_change/ip", limit: 5, period: 60) do |req|
    req.ip if req.path == "/email_change" && req.post?
  end

  throttle("graphql/ip", limit: 30, period: 10) do |req|
    req.ip if req.path == "/graphql" && req.post?
  end
end

# Disabled in test by default since the request-spec suite reuses the same
# IP/emails across many examples in one process; spec/requests/rack_attack_spec.rb
# explicitly re-enables it to verify these throttles.
Rack::Attack.enabled = !Rails.env.test?

# The vendored super_admin engine (lib/super_admin/engine.rb:46, see
# config/application.rb) loads its own bundled rack-attack config once
# Rack::Attack is defined. That config's throttles/blocklists are scoped to
# /super_admin (inert here -- this app mounts the engine at /admin), but it
# also sets a GLOBAL Rack::Attack.throttled_responder returning a JSON body,
# which would silently apply to the throttles above too -- including the
# HTML sign-in form, where a raw JSON response is a poor error page. That
# engine initializer runs after this whole file, so re-asserting our own
# responder in after_initialize (which runs after every named initializer)
# is what makes ours win instead of being silently overridden.
Rails.application.config.after_initialize do
  Rack::Attack.throttled_responder = lambda do |request|
    period = request.env["rack.attack.match_data"]&.fetch(:period, nil)
    [ 429, { "Content-Type" => "text/plain", "Retry-After" => period.to_s }, [ "Too many requests. Please try again later.\n" ] ]
  end
end
