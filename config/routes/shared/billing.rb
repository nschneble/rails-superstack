# Stripe payments

namespace :billing do
  post "checkout",         to: "checkout#create",  as: :checkout
  get  "checkout/success", to: "checkout#success", as: :checkout_success
  get  "plans",            to: "plans#index",      as: :plans
  post "portal",           to: "portal#create",    as: :portal
end

post "webhooks/stripe",
     to: "billing/webhooks#create",
     as: :stripe_webhook
