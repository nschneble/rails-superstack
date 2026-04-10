module Demo
  # Lists purchasable demo themes and initiates checkout for theme purchases
  class ThemesController < DemoAuthenticatedController
    include Redirectable

    def index
      @themes = Themes::ThemePurchase::THEMES
      @purchases = Themes::ThemePurchase.accessible_by(current_ability).completed.pluck(:theme_key)
    end

    def checkout
      result = Themes::CreateCheckoutSessionService.call(
        user: current_user,
        theme_key:,
        success_url: demo_themes_url(purchased: theme_key),
        cancel_url: demo_themes_url
      )

      redirect_to_stripe_url(
        result,
        fallback_path: demo_themes_path,
        fallback_alert: t("themes.checkout.#{result.error}")
      )
    end

    private

    def theme_key
      params[:theme_key]
    end
  end
end
