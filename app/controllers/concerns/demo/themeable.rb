module Demo
  # Resolves a current demo theme from the user's theme purchases
  module Themeable
    extend ActiveSupport::Concern

    included do
      helper_method :current_theme, :theme_purchases
    end

    private

    def current_theme
      return Themes::Theme.default if theme_purchases.empty?

      @current_theme ||= Themes::Theme.find(theme_purchases.sample)
    end

    def theme_purchases
      @theme_purchases ||= Themes::ThemePurchase.accessible_by(current_ability).completed.pluck(:theme_key)
    end
  end
end
