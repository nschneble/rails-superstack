require "rails_helper"

RSpec.describe "Settings", type: :request do
  describe "GET /settings/billing" do
    it "shows the manage billing button for pro subscribers" do
      user = create(:user)
      create(:subscription, :pro_monthly, user:)
      passwordless_sign_in(user)

      get settings_billing_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(I18n.t("settings.billing.manage_billing"))
    end
  end
end
