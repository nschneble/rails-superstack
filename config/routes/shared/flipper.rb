# beautiful, performant feature flags
constraints(Passwordless::Constraint.new(User, if: ->(user) { user.admin? })) do
  mount Flipper::UI.app(Flipper), at: "/flipper", as: :flipper
end

# denies access to anonymous and non-admin users
match "/flipper(/*path)", to: "not_authorized#denied", via: :all
