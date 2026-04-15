module SuperAdmin
  # SuperAdmin dashboard for demo theme purchases
  class Demo::Themes::ThemePurchaseDashboard < BaseDashboard
    # Attributes shown in the table view
    def collection_attributes
      %i[id status stripe_checkout_session_id stripe_payment_intent_id theme_key user_id]
    end

    # Attributes shown in the detail view
    def show_attributes
      %i[id status stripe_checkout_session_id stripe_payment_intent_id theme_key user_id]
    end

    # Attributes shown in the form
    def form_attributes
      %i[status stripe_checkout_session_id stripe_payment_intent_id theme_key user_id]
    end
  end
end
