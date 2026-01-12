Rails.application.routes.draw do
  # returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check

  # preview emails in development
  mount LetterOpenerWeb::Engine, at: "/sent_mail" if Rails.env.development?

  # admin interface
  mount SuperAdmin::Engine, at: "/admin"

  # authentication
  passwordless_for :users, at: "/", as: :auth, controller: "sessions"

  # defines the root path route ("/")
  root "application#home"

  # tests flash notices
  get "notice" => "flash#notice", as: :flash_notice
  get "alert"  => "flash#alert",  as: :flash_alert

  # models and resources
  resources :mac_guffins, only: [ :index ]
  resource :email_change, only: [ :create ]

  # all other paths
  get "profile" => "users#show", as: :user_profile
  get "email_change/confirm" => "email_changes#confirm", as: :confirm_email_change
end
