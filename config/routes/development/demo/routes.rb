namespace :demo do
  get "alert",  to: "flash#alert",  as: :alert
  get "notice", to: "flash#notice", as: :notice

  get "mac_guffins", to: "pages#mac_guffins", as: :mac_guffins
  get "terminal",    to: "pages#terminal",    as: :terminal
  get "welcome",     to: "pages#welcome",     as: :welcome

  # a "secret" route behind a feature flag
  get "secrets", to: "secrets#sssssh", as: :secrets
end
