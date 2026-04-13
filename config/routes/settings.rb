namespace :settings do
  get "profile",    to: "settings#profile", as: :profile
  get "api",        to: "settings#api",     as: :api
  get "billing",    to: "settings#billing", as: :billing

  root to: redirect("/settings/profile")
end

# Passwordless email updates
post "email_change", to: "email_changes#create", as: :create_email_change
get  "email_change", to: "email_changes#update", as: :update_email_change
