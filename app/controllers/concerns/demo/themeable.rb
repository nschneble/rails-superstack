module Demo::Themeable
  extend ActiveSupport::Concern

  included do
    helper_method :current_theme
  end

  private

  def current_theme
    return Demo::Themes::DefaultTheme if purchases.empty?

    @current_theme ||= Demo::Themes::ThemePurchase::THEMES[purchases.sample]
  end

  def purchases
    @purchases ||= Demo::Themes::ThemePurchase.accessible_by(current_ability).completed.pluck(:theme_key)
  end
end
