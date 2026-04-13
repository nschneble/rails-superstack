require "rails_helper"

RSpec.describe StripeSubscriptionParser do
  subject(:parser) { described_class.new }

  include_context "with Stripe subscription builder"


  before do
    allow(Figaro.env).to receive_messages(
      stripe_price_pro_monthly: "price_monthly_test",
      stripe_price_pro_yearly: "price_yearly_test"
    )
  end

  it "maps the configured monthly price id to pro_monthly" do
    result = parser.call(build_stripe_subscription(price_id: "price_monthly_test"))

    expect(result[:plan]).to eq("pro_monthly")
  end

  it "maps the configured yearly price id to pro_yearly" do
    result = parser.call(build_stripe_subscription(price_id: "price_yearly_test"))

    expect(result[:plan]).to eq("pro_yearly")
  end

  it "maps a missing price id to free" do
    result = parser.call(build_stripe_subscription(price_id: nil))

    expect(result[:plan]).to eq("free")
  end

  it "raises for an unknown price id" do
    expect {
      parser.call(build_stripe_subscription(price_id: "price_unknown"))
    }.to raise_error(StripeSubscriptionParser::UnknownPriceError, "Unknown Stripe price id: price_unknown")
  end

  it "converts unix timestamps to zoned times" do
    timestamp = 2.days.from_now.to_i
    result = parser.call(build_stripe_subscription(price_id: nil, current_period_end: timestamp))

    expect(result[:current_period_end_at]).to be_within(1.second).of(Time.zone.at(timestamp))
  end
end
