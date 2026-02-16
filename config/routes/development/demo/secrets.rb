namespace :demo do
  # a "secret" route behind a feature flag
  get "secrets", to: "secrets#sssssh", as: :secrets
end
