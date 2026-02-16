# authentication without the icky-ness of passwords
passwordless_for :users, at: "/", as: :auth, controller: "sessions"
