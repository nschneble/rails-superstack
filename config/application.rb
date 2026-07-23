require_relative "boot"

require "rails/all"

# The vendored super_admin engine fork (github.com/nschneble/super_admin,
# lib/super_admin/engine.rb:46) runs `require "rack-attack"` (hyphen, wrong
# path -- the gem's real path is "rack/attack") the moment `defined?(Rack::Attack)`
# is true, in an initializer that always runs once this app also requires
# Rack::Attack (see the Gemfile). That require path never resolves and
# crashes boot. This shim directory supplies a `rack-attack.rb` file that
# just requires the real path, so that broken call succeeds (a harmless
# no-op re-require) instead of crashing. Needs to be on $LOAD_PATH before
# that initializer runs, hence here rather than config/initializers/.
# TODO: remove this and vendor/rack_attack_shim/ once upstream fixes the typo.
$LOAD_PATH.unshift(File.expand_path("../vendor/rack_attack_shim", __dir__))

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsSuperstack
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.session_store :cookie_store, expire_after: 1.year
  end
end
