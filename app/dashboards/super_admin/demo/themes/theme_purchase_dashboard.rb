# SuperAdmin dashboard for demo theme purchases

class SuperAdmin::Demo::Themes::ThemePurchaseDashboard < SuperAdmin::BaseDashboard
  resource Demo::Themes::ThemePurchase

  collection_attributes :id, :status, :stripe_checkout_session_id, :stripe_payment_intent_id, :theme_key, :user_id
  show_attributes :id, :status, :stripe_checkout_session_id, :stripe_payment_intent_id, :theme_key, :user_id
  form_attributes :status, :stripe_checkout_session_id, :stripe_payment_intent_id, :theme_key, :user_id
end
