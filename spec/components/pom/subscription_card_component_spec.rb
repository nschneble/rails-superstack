require "rails_helper"

RSpec.describe Pom::SubscriptionCardComponent, type: :component do
  let(:plan) do
    Struct.new(:key, :stripe_price_monthly_id, :stripe_price_yearly_id).new(
      :pro,
      -> { "price_monthly_test" },
      -> { "price_yearly_test" }
    )
  end

  it "returns the monthly Stripe price id for monthly cards" do
    component = described_class.new(plan:, term: :monthly)

    expect(component.stripe_price_id).to eq("price_monthly_test")
  end

  it "returns the yearly Stripe price id for yearly cards" do
    component = described_class.new(plan:, term: :yearly)

    expect(component.stripe_price_id).to eq("price_yearly_test")
  end
end
