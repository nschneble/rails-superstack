require "rails_helper"

RSpec.describe Demo::ThemesController, type: :controller do
  include Passwordless::TestHelpers

  before do
    Rails.application.routes.draw do
      get  "demo/themes",          to: "demo/themes#index",    as: :demo_themes
      post "demo/themes/checkout", to: "demo/themes#checkout", as: :demo_theme_checkout
      get "sign_in",               to: "sessions#new",         as: :auth_sign_in
    end
  end

  after  { Rails.application.reload_routes! }

  describe "POST #checkout" do
    it "requires authentication" do
      post :checkout, params: { theme_key: "midnight_galaxy" }
      expect(response).to redirect_to(auth_sign_in_path)
    end

    it "redirects to Stripe on success" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Demo::Themes::CreateCheckoutSessionService).to receive(:call).and_return(
        ServiceResult.ok(instance_double(Stripe::Checkout::Session, url: "https://checkout.stripe.com/theme"))
      )

      post :checkout, params: { theme_key: "midnight_galaxy" }
      expect(response).to redirect_to("https://checkout.stripe.com/theme")
    end

    it "redirects with alert when purchase fails" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Demo::Themes::CreateCheckoutSessionService).to receive(:call).and_return(
        ServiceResult.fail(:invalid_theme)
      )

      post :checkout, params: { theme_key: "midnight_galaxy" }
      expect(response).to redirect_to(demo_themes_path)
    end
  end
end
