namespace :settings do
  get "profile",    to: "settings#profile", as: :profile
  get "api",        to: "settings#api",     as: :api
  get "billing",    to: "settings#billing", as: :billing

  root to: redirect("/settings/profile")
end

# Passwordless email updates
resource :email_change, only: [ :create, :update ]
