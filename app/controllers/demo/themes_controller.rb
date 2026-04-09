module Demo
  # Lists purchasable demo themes and initiates checkout for theme purchases
  class ThemesController < DemoAuthenticatedController
    def index
      @themes = Themes::ThemePurchase::THEMES
      @purchases = Themes::ThemePurchase.accessible_by(current_ability).completed.pluck(:theme_key)
    end

    def checkout
      theme_key = params[:theme_key]
      result = Themes::CreateCheckoutSessionService.call(
        user: current_user,
        theme_key:,
        success_url: demo_themes_url(purchased: theme_key),
        cancel_url: demo_themes_url
      )

      if result.success?
        redirect_to result.payload.url, allow_other_host: true
      else
        redirect_to demo_themes_path, alert: t("themes.checkout.#{result.error}")
      end
    end
  end
end
