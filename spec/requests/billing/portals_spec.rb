require "rails_helper"

RSpec.describe "Billing::Portals", type: :request do
  describe "POST /billing/portal" do
    it "requires authentication" do
      post billing_portal_path
      expect(response).to redirect_to(auth_sign_in_path)
    end

    it "redirects to Stripe portal on success" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Billing::CreatePortalSessionService).to receive(:call).and_return(
        ServiceResult.ok(instance_double(Stripe::BillingPortal::Session, url: "https://billing.stripe.com/portal"))
      )

      post billing_portal_path
      expect(response).to redirect_to("https://billing.stripe.com/portal")
    end

    it "redirects to settings with alert on failure" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Billing::CreatePortalSessionService).to receive(:call).and_return(
        ServiceResult.fail(:no_customer)
      )

      post billing_portal_path
      expect(response).to redirect_to(settings_profile_path)
    end
  end
end
