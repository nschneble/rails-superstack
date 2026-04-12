# a "secret" route behind a feature flag

if Rails.env.development?
  namespace :demo do
    get "secrets", to: "secrets#sssh", as: :secrets
  end
end
