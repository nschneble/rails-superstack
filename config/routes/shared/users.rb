# handles Passwordless email updates
resource :email_change, only: [ :create, :update ]

get "profile", to: "users#me", as: :user_profile
