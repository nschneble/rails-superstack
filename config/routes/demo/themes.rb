# Stripe payments for demo themes

if Rails.env.development?
  namespace :demo do
    get  "themes",          to: "themes#index",    as: :themes
    post "themes/checkout", to: "themes#checkout", as: :theme_checkout
  end
end
