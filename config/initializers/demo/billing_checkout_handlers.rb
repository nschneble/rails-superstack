Rails.application.config.to_prepare do
  Billing::Webhooks::CheckoutCompleteHandler.register(
    "payment",
    Demo::Themes::CompletePurchaseService
  )
end
