require "rails_helper"

RSpec.describe Billing::Plan do
  let(:plan) do
    described_class.new(
      key: :test,
      name: "Test Plan",
      price_monthly_cents: 1000,
      price_yearly_cents: 9600,
      stripe_price_monthly_id: -> { "price_monthly_123" },
      stripe_price_yearly_id: -> { "price_yearly_456" }
    )
  end

  describe "#free?" do
    it "returns false when prices are set" do
      expect(plan.free?).to be(false)
    end

    it "returns true when both prices are zero" do
      free_plan = described_class.new(key: :free, name: "Free")
      expect(free_plan.free?).to be(true)
    end
  end

  describe "#stripe_price_id" do
    it "returns the monthly price ID for :monthly term" do
      expect(plan.stripe_price_id(:monthly)).to eq("price_monthly_123")
    end

    it "returns the yearly price ID for :yearly term" do
      expect(plan.stripe_price_id(:yearly)).to eq("price_yearly_456")
    end

    it "returns nil for an unrecognized term" do
      expect(plan.stripe_price_id(:quarterly)).to be_nil
    end

    it "returns nil for a nil term" do
      expect(plan.stripe_price_id(nil)).to be_nil
    end
  end
end
