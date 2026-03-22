namespace :billing do
  post "checkout", to: "checkouts#create", as: :checkout
  get  "checkout/success", to: "checkouts#success", as: :checkout_success
  post "portal", to: "portals#create", as: :portal
end

post "webhooks/stripe", to: "billing/webhooks#create", as: :stripe_webhook
