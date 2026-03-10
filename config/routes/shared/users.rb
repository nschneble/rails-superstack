get "profile", to: "users#me", as: :user_profile

# handles Passwordless email updates
resource :email_change, only: [ :create, :update ]

# handles API tokens
post   "profile/api_tokens",     to: "api_tokens#create",  as: :user_profile_api_tokens
delete "profile/api_tokens/:id", to: "api_tokens#destroy", as: :user_profile_api_token
