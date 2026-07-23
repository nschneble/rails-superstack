SuperAdmin.configure do |config|
  # Maximum depth for nested associations when displaying resources
  # config.max_nested_depth = 2

  # Limit for association select dropdowns
  # config.association_select_limit = 10

  # Pagination limit for associations lists
  # config.association_pagination_limit = 20

  # Enable or disable search in association selects
  # config.enable_association_search = true

  # Authentication
  # Configure how to authenticate users accessing SuperAdmin
  config.authenticate_with = proc { authenticate_user! }

  # Current user method
  # Method to call to get the current user
  config.current_user_method = :current_user

  # User class
  # The class representing users in your application
  config.user_class = "User"

  # Authorization
  # Configure authorization adapter (:auto, :pundit, :proc, or :custom).
  # NOTE: this app uses CanCanCan (lib/abilities/), but the installed
  # super_admin gem (0.2.1) has no CancanAdapter -- only default, pundit, and
  # proc adapters exist. Setting :cancancan here silently no-ops to
  # DefaultAdapter (which happens to check current_user.admin? directly,
  # since no super_admin_check is configured below). Using :proc instead
  # makes that same check explicit rather than relying on an undocumented
  # fallback. See spec/requests/super_admin_authorization_spec.rb.
  config.authorization_adapter = :proc
  config.authorize_with = proc { current_user&.admin? }

  # What to do when authorization fails
  config.on_unauthorized = proc { |controller|
    # redirect_to main_app.root_path, alert: "You are not authorized to access this page."
    raise User::NotAuthorized, t("super_admin.flash.access_denied")
  }

  # Super admin check
  # Additional check to determine if current user is a super admin
  # config.super_admin_check = proc { |user|
  #   user.has_role?(:super_admin)
  # }

  # Layout
  # Layout to use for SuperAdmin views
  # config.layout = "super_admin"

  # Parent controller
  # Controller from which SuperAdmin controllers inherit
  config.parent_controller = "::ApplicationController"

  # Default locale
  config.default_locale = :en
end
