Rails.application.routes.draw do
  # returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check

  # preview emails in development
  mount LetterOpenerWeb::Engine, at: "/sent_mail" if Rails.env.development?

  # authentication
  passwordless_for :users, at: "/", as: :auth, controller: "sessions"

  # defines the root path route ("/")
  root "application#home"
end
