# Redis-backed library for creating background jobs
constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? })) do
  mount Resque::Server.new, at: "/resque", as: :resque
end

# denies access to anonymous and non-admin users
match "/resque(/*path)" => "not_authorized#denied", via: :all
