# authentication without the icky-ness of passwords
passwordless_for :users, at: "/", as: :auth, controller: "sessions"

resource :email_change, only: [ :create ]

get "email_change/confirm" => "email_changes#confirm", as: :confirm_email_change
get "profile" => "users#show", as: :user_profile
