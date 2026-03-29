# Stripe payments for demo themes

namespace :demo do
  get  "themes",          to: "themes#index",    as: :themes
  post "themes/checkout", to: "themes#checkout", as: :theme_checkout
end
