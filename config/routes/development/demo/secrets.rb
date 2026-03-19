# a "secret" route behind a feature flag

namespace :demo do
  get "secrets", to: "secrets#sssh", as: :secrets
end
