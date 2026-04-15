require "rails_helper"

RSpec.describe "Billing settings tab", type: :system do
  describe "as a free user" do
    let(:user) { create(:user) }

    before { sign_in_as(user) }

    it "shows the current plan as Free" do
      visit settings_billing_path

      expect(page).to have_text("Free")
    end

    it "shows an Upgrade to Pro link to the plans page" do
      visit settings_billing_path

      expect(page).to have_text("Upgrade to Pro")
    end
  end

  describe "as a pro subscriber" do
    let(:user) { create(:user) }

    before do
      create(:subscription, :pro_monthly, user:)
      sign_in_as(user)
    end

    it "shows the current plan as Pro (Monthly)" do
      visit settings_billing_path

      expect(page).to have_text("Pro (Monthly)")
    end

    it "shows a Manage billing button" do
      visit settings_billing_path

      expect(page).to have_text("Manage billing")
    end

    it "redirects when Manage billing is clicked" do
      allow(Billing::CreatePortalSessionService).to receive(:call)
        .and_return(ServiceResult.ok(double(url: "/")))

      visit settings_billing_path
      click_on "Manage billing"

      expect(page).to have_current_path(root_path)
    end
  end
end
