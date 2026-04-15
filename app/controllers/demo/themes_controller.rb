module Demo
  # Lists purchasable demo themes and initiates checkout for theme purchases
  class ThemesController < DemoAuthenticatedController
    include Redirectable

    helper_method :purchased_key

    def index
      @themes = Themes::ThemeDecorator.decorate_collection(Themes::Theme.purchasable)
      @purchases = theme_purchases
      @purchases |= [ purchased_key ] if purchased_key.present?
    end

    def checkout
      result = Themes::CreateCheckoutSessionService.call(
        user: current_user,
        theme_key:,
        urls: {
          success: demo_themes_url(purchased: theme_key),
          cancel:  demo_themes_url
        }
      )

      redirect_to_stripe_url(
        result,
        fallback_path:  demo_themes_path,
        fallback_alert: t("themes.checkout.#{result.error}")
      )
    end

    private

    def theme_key
      params[:theme_key]
    end

    def purchased_key
      key = params[:purchased]
      @purchased_key ||= key if key.present? && Themes::Theme.find(key)
    end
  end
end
