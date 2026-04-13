require "rails_helper"

RSpec.describe "Billing plans page", type: :system do
  describe "as an unauthenticated user" do
    it "renders the plans page publicly" do
      visit billing_plans_path

      expect(page).to have_text("Simple, Transparent Pricing")
      expect(page).to have_text("Free")
      expect(page).to have_text("Pro")
    end
  end

  describe "as a free user" do
    it "renders the plans page" do
      sign_in_as(create(:user))

      visit billing_plans_path

      expect(page).to have_text("Simple, Transparent Pricing")
    end
  end

  describe "as a pro subscriber" do
    it "highlights the current plan" do
      user = create(:user)
      create(:subscription, :pro_monthly, user:)
      sign_in_as(user)

      visit billing_plans_path

      expect(page).to have_text("CURRENT PLAN")
    end
  end
end
