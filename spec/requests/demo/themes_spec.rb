require "rails_helper"

RSpec.describe "Demo::Themes", type: :request do
  describe "GET /demo/themes" do
    it "requires authentication" do
      get demo_themes_path
      expect(response).to redirect_to(auth_sign_in_path)
    end

    it "renders the themes page with all three themes" do
      user = create(:user)
      passwordless_sign_in(user)
      get demo_themes_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Midnight Galaxy")
      expect(response.body).to include("Crimson Tide")
      expect(response.body).to include("Forest Canopy")
    end

    it "shows a purchased badge for themes the user has bought" do
      user = create(:user)
      create(:demo_theme_purchase, :completed, user:, theme_key: "crimson_tide")
      passwordless_sign_in(user)
      get demo_themes_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /demo/themes/checkout" do
    it "requires authentication" do
      post demo_theme_checkout_path, params: { theme_key: "midnight_galaxy" }
      expect(response).to redirect_to(auth_sign_in_path)
    end

    it "redirects to Stripe on success" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Demo::Themes::CreateCheckoutSessionService).to receive(:call).and_return(
        ServiceResult.ok(instance_double(Stripe::Checkout::Session, url: "https://checkout.stripe.com/theme"))
      )

      post demo_theme_checkout_path, params: { theme_key: "midnight_galaxy" }
      expect(response).to redirect_to("https://checkout.stripe.com/theme")
    end

    it "redirects with alert when purchase fails" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Demo::Themes::CreateCheckoutSessionService).to receive(:call).and_return(
        ServiceResult.fail(:invalid_theme)
      )

      post demo_theme_checkout_path, params: { theme_key: "midnight_galaxy" }
      expect(response).to redirect_to(demo_themes_path)
    end
  end
end
