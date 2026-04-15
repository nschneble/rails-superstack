require "rails_helper"

RSpec.describe Subscribable, type: :model do
  describe "#subscription" do
    it "returns a new Subscription instance when none exists" do
      user = build(:user)
      expect(user.subscription).to be_a(Subscription)
      expect(user.subscription).to be_new_record
    end
  end

  describe "#stripe_customer_id" do
    it "delegates to the subscription" do
      user = create(:user)
      create(:subscription, user:, stripe_customer_id: "cus_test123")
      expect(user.reload.stripe_customer_id).to eq("cus_test123")
    end
  end

  describe "#stripe_subscription_id" do
    it "delegates to the subscription" do
      user = create(:user)
      create(:subscription, user:, stripe_subscription_id: "sub_test123")
      expect(user.reload.stripe_subscription_id).to eq("sub_test123")
    end
  end

  describe "#subscription_plan" do
    it "delegates plan to the subscription with prefix" do
      user = create(:user)
      create(:subscription, user:, plan: "pro_monthly", status: :active)
      expect(user.reload.subscription_plan).to eq("pro_monthly")
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
