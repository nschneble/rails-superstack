require "rails_helper"

RSpec.describe Billing::Plan do
  describe "#free?" do
    it "returns false when prices are set" do
      paid_plan = described_class.new(
        key: :paid,
        name: "Paid Plan",
        description: "This is a paid plan.",
        price_monthly_cents: 1000,
        price_yearly_cents: 9600,
        stripe_price_monthly_id: -> { "price_monthly_123" },
        stripe_price_yearly_id: -> { "price_yearly_456" },
        features: []
      )
      expect(paid_plan.free?).to be(false)
    end

    it "returns true when both prices are zero" do
      free_plan = described_class.new(
        key: :free,
        name: "Free Plan",
        description: "This is a free plan.",
        price_monthly_cents: 0,
        price_yearly_cents: 0,
        stripe_price_monthly_id: nil,
        stripe_price_yearly_id: nil,
        features: []
      )
      expect(free_plan.free?).to be(true)
    end
  end
end
