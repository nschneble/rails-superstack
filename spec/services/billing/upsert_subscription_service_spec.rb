require "rails_helper"

RSpec.describe Billing::UpsertSubscriptionService, type: :service do
  include_context "with stubbed Stripe client"
  include_context "with Stripe subscription builder"

  let(:user) { create(:user) }

  def call(stripe_subscription:, stripe_customer_id:)
    described_class.call(stripe_subscription:, stripe_customer_id:)
  end

  describe "when no subscription exists for the customer ID" do
    it "returns a failure with :user_not_found" do
      stripe_sub = build_stripe_subscription(price_id: nil)
      result = call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_unknown")
      expect(result).to be_failure
      expect(result.error).to eq(:user_not_found)
    end
  end

  describe "plan resolution" do
    before do
      create(:subscription, user:, stripe_customer_id: "cus_test")
      allow(Figaro.env).to receive_messages(stripe_price_pro_monthly: "price_monthly_test", stripe_price_pro_yearly: "price_yearly_test")
    end

    it "sets plan to pro_monthly when price_id matches stripe_price_pro_monthly" do
      stripe_sub = build_stripe_subscription(price_id: "price_monthly_test")
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.plan).to eq("pro_monthly")
    end

    it "sets plan to pro_yearly when price_id matches stripe_price_pro_yearly" do
      stripe_sub = build_stripe_subscription(price_id: "price_yearly_test")
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.plan).to eq("pro_yearly")
    end

    it "returns failure and preserves the current plan when price_id is unknown" do
      user.subscription.update!(plan: "pro_monthly")
      stripe_sub = build_stripe_subscription(price_id: "price_unknown")
      result = call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")

      expect(result).to be_failure
      expect(result.error).to eq(:unknown_price_id)
      expect(user.reload.subscription.plan).to eq("pro_monthly")
    end
  end

  describe "time conversion" do
    before do
      create(:subscription, user:, stripe_customer_id: "cus_test")
    end

    it "sets cancel_at to nil when Stripe returns nil" do
      stripe_sub = build_stripe_subscription(price_id: nil, cancel_at: nil)
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.cancel_at).to be_nil
    end

    it "converts a unix timestamp to a Time when cancel_at is present" do
      future_ts = 30.days.from_now.to_i
      stripe_sub = build_stripe_subscription(price_id: nil, cancel_at: future_ts)
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.cancel_at).to be_within(1.second).of(Time.zone.at(future_ts))
    end
  end
end
