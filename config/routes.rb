Rails.application.routes.draw do
  # returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check

  # preview emails in development
  mount LetterOpenerWeb::Engine, at: "/sent_mail", as: :letter_opener if Rails.env.development?

  # admin dashboard
  mount SuperAdmin::Engine, at: "/admin", as: :admin

  # feature flags
  constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? })) do
    mount Flipper::UI.app(Flipper), at: "/flipper", as: :flipper
  end
  match "/flipper(/*path)" => "not_authorized#denied", via: :all

  # background jobs
  constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? })) do
    mount Resque::Server.new, at: "/resque", as: :resque
  end
  match "/resque(/*path)" => "not_authorized#denied", via: :all

  # authentication
  passwordless_for :users, at: "/", as: :auth, controller: "sessions"
  resource :email_change, only: [ :create ]

  # user profile
  get "email_change/confirm" => "email_changes#confirm", as: :confirm_email_change
  get "profile" => "users#show", as: :user_profile

  # defines the root path route
  root "application#root"

  # config/routes/demo.rb
  draw(:demo)
end
