require "rails_helper"

RSpec.describe Subscription, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    subject { build(:subscription) }

    it { should validate_presence_of(:stripe_customer_id) }
    it { should validate_uniqueness_of(:stripe_customer_id) }
    it { should validate_inclusion_of(:plan).in_array(described_class::PLANS) }
  end

  describe "#active?" do
    it "returns true for active status" do
      sub = build(:subscription, status: :active)
      expect(sub.active?).to be(true)
    end

    it "returns true for trialing status" do
      sub = build(:subscription, status: :trialing)
      expect(sub.active?).to be(true)
    end

    it "returns false for canceled status" do
      sub = build(:subscription, status: :canceled)
      expect(sub.active?).to be(false)
    end

    it "returns false for past_due status" do
      sub = build(:subscription, status: :past_due)
      expect(sub.active?).to be(false)
    end
  end

  describe "#pro?" do
    it "returns true for pro_monthly" do
      sub = build(:subscription, :pro_monthly)
      expect(sub.pro?).to be(true)
    end

    it "returns true for pro_yearly" do
      sub = build(:subscription, :pro_yearly)
      expect(sub.pro?).to be(true)
    end

    it "returns false for free" do
      sub = build(:subscription, plan: "free")
      expect(sub.pro?).to be(false)
    end
  end

  describe "#on_trial?" do
    it "returns true when trialing with a future trial_ends_at" do
      sub = build(:subscription, status: :trialing, trial_ends_at: 7.days.from_now)
      expect(sub.on_trial?).to be(true)
    end

    it "returns false when trialing but trial_ends_at is in the past" do
      sub = build(:subscription, status: :trialing, trial_ends_at: 1.day.ago)
      expect(sub.on_trial?).to be(false)
    end

    it "returns false when active (not trialing)" do
      sub = build(:subscription, status: :active, trial_ends_at: 7.days.from_now)
      expect(sub.on_trial?).to be(false)
    end
  end

  describe "scopes" do
    describe ".active_or_trialing" do
      it "includes active and trialing subscriptions" do
        active = create(:subscription)
        trialing = create(:subscription, :trialing, user: create(:user))
        canceled = create(:subscription, :canceled, user: create(:user))

        result = described_class.active_or_trialing
        expect(result).to include(active, trialing)
        expect(result).not_to include(canceled)
      end
    end
  end
end
