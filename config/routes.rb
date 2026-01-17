Rails.application.routes.draw do
  # returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check

  # preview emails in development
  mount LetterOpenerWeb::Engine, at: "/sent_mail" if Rails.env.development?

  # admin dashboard
  mount SuperAdmin::Engine, at: "/admin"

  # feature flags
  constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? })) do
    mount Flipper::UI.app(Flipper), at: "/flipper"
  end
  match "/flipper(/*path)" => "not_authorized#denied", via: :all

  # `secret_menu` feature flag
  constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? && Flipper.enabled?(:secret_menu, user) })) do
    get SecureRandom.uuid => "application#secret", as: :secret_menu
  end

  # background jobs
  constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? })) do
    mount Resque::Server.new, at: "/resque"
  end
  match "/resque(/*path)" => "not_authorized#denied", via: :all

  # authentication
  passwordless_for :users, at: "/", as: :auth, controller: "sessions"

  # defines the root path route ("/")
  root "application#welcome"

  # tests flash notices
  get "notice" => "flash#notice", as: :flash_notice
  get "alert"  => "flash#alert",  as: :flash_alert

  # models and resources
  resources :mac_guffins, only: [ :index ]
  resource :email_change, only: [ :create ]

  # all other paths
  get "email_change/confirm" => "email_changes#confirm", as: :confirm_email_change
  get "profile" => "users#show", as: :user_profile
  get "terminal_commands" => "application#terminal", as: :terminal_commands
end
