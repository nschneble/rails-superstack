Rails.application.config.to_prepare do
  User.class_eval do
    has_many :theme_purchases, class_name: "Demo::Themes::ThemePurchase", dependent: :destroy
  end
end
