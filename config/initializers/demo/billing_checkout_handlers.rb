Rails.application.config.after_initialize do
  Billing::Webhooks::CheckoutCompleteHandler.register(
    "payment",
    Demo::Themes::CompletePurchaseService
  )
end
