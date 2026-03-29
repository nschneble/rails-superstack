require "rails_helper"

RSpec.describe Subscription, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    subject { build(:subscription) }

    it { is_expected.to validate_presence_of(:stripe_customer_id) }
    it { is_expected.to validate_uniqueness_of(:stripe_customer_id) }
    it { is_expected.to validate_inclusion_of(:plan).in_array(described_class::PLANS) }
  end

  describe "#active?" do
    it "returns true for active status" do
      subscription = build(:subscription, status: :active)
      expect(subscription.active?).to be(true)
    end

    it "returns true for trialing status" do
      subscription = build(:subscription, status: :trialing)
      expect(subscription.active?).to be(true)
    end

    it "returns false for canceled status" do
      subscription = build(:subscription, status: :canceled)
      expect(subscription.active?).to be(false)
    end

    it "returns false for past_due status" do
      subscription = build(:subscription, status: :past_due)
      expect(subscription.active?).to be(false)
    end
  end

  describe "#pro?" do
    it "returns true for pro_monthly" do
      subscription = build(:subscription, :pro_monthly)
      expect(subscription.pro?).to be(true)
    end

    it "returns true for pro_yearly" do
      subscription = build(:subscription, :pro_yearly)
      expect(subscription.pro?).to be(true)
    end

    it "returns false for free" do
      subscription = build(:subscription, plan: "free")
      expect(subscription.pro?).to be(false)
    end
  end

  describe "#on_trial?" do
    it "returns true when trialing with a future trial_ends_at" do
      subscription = build(:subscription, status: :trialing, trial_ends_at: 7.days.from_now)
      expect(subscription.on_trial?).to be(true)
    end

    it "returns false when trialing but trial_ends_at is in the past" do
      subscription = build(:subscription, status: :trialing, trial_ends_at: 1.day.ago)
      expect(subscription.on_trial?).to be(false)
    end

    it "returns false when active (not trialing)" do
      subscription = build(:subscription, status: :active, trial_ends_at: 7.days.from_now)
      expect(subscription.on_trial?).to be(false)
    end
  end
end
