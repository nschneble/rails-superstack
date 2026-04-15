# Noticed notifications
constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? })) do
  resources :notifications, only: [ :index, :create ]
end

# denies access to anonymous and non-admin users
match "/notifications(/*path)", to: "not_authorized#denied", via: :all
