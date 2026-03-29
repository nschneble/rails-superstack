FactoryBot.define do
  factory :demo_theme_purchase, class: "Demo::Themes::ThemePurchase" do
    user
    theme_key { "midnight_galaxy" }
    status { :pending }
    stripe_checkout_session_id { "cs_#{SecureRandom.hex(8)}" }

    trait :completed do
      status { :completed }
      stripe_payment_intent_id { "pi_#{SecureRandom.hex(8)}" }
    end

    trait :crimson_tide do
      theme_key { "crimson_tide" }
    end

    trait :forest_canopy do
      theme_key { "forest_canopy" }
    end
  end
end
