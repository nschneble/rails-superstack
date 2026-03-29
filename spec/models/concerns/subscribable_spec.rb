require "rails_helper"

RSpec.describe Subscribable, type: :model do
  describe "#subscription" do
    it "returns a new Subscription instance when none exists" do
      user = build(:user)
      expect(user.subscription).to be_a(Subscription)
      expect(user.subscription).to be_new_record
    end
  end

  describe "#pro_subscription?" do
    it "returns false when on a free plan" do
      user = create(:user)
      create(:subscription, user:, plan: "free", status: :active)
      expect(user.reload.pro_subscription?).to be(false)
    end

    it "returns true when on a pro monthly plan" do
      user = create(:user)
      create(:subscription, :pro_monthly, user:, status: :active)
      expect(user.reload.pro_subscription?).to be(true)
    end
  end
end
