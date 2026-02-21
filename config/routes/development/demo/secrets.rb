# a "secret" route behind a feature flag

namespace :demo do
  get "secrets", to: "secrets#sssssh", as: :secrets
end
