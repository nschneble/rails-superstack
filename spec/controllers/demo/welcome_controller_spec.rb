require "rails_helper"

RSpec.describe Demo::WelcomeController, type: :controller do
  include Passwordless::TestHelpers
  include_context "with demo routes"

  describe "GET #show" do
    it "returns ok when not signed in" do
      get :show
      expect(response).to have_http_status(:ok)
    end

    it "returns ok when signed in" do
      user = create(:user)
      passwordless_sign_in(user)

      get :show
      expect(response).to have_http_status(:ok)
    end

    it "renders with a purchased theme when the user has completed purchases" do
      user = create(:user)
      create(:demo_theme_purchase, :completed, user:)
      passwordless_sign_in(user)

      get :show
      expect(response).to have_http_status(:ok)
    end
  end
end
