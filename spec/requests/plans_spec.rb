require "rails_helper"

RSpec.describe "Plans", type: :request do
  describe "GET /plans" do
    it "renders the plans page for guests" do
      get billing_plans_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Free")
      expect(response.body).to include("Pro")
    end

    it "renders the plans page for authenticated users" do
      user = create(:user)
      passwordless_sign_in(user)
      get billing_plans_path
      expect(response).to have_http_status(:ok)
    end

    it "shows a manage billing button for Pro subscribers" do
      user = create(:user)
      create(:subscription, :pro_monthly, user:)
      passwordless_sign_in(user)
      get billing_plans_path
      expect(response.body).to include("Manage Billing")
    end
  end
end
