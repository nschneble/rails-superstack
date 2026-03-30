require "rails_helper"

RSpec.describe Billing::UpsertSubscriptionService, type: :service do
  include_context "with stubbed Stripe client"

  let(:user) { create(:user) }

  def build_stripe_sub(price_id:, cancel_at: nil, period_end: 30.days.from_now.to_i, trial_end: nil)
    # rubocop:disable RSpec/VerifiedDoubles
    sub = double(
      "Stripe::Subscription",
      id: "sub_test",
      status: "active",
      items: double("items", data: [
        double("item", price: double("price", id: price_id))
      ])
    )
    # rubocop:enable RSpec/VerifiedDoubles
    allow(sub).to receive(:[]).with("cancel_at").and_return(cancel_at)
    allow(sub).to receive(:[]).with("current_period_end").and_return(period_end)
    allow(sub).to receive(:[]).with("trial_end").and_return(trial_end)
    sub
  end

  def call(stripe_subscription:, stripe_customer_id:)
    described_class.call(stripe_subscription:, stripe_customer_id:)
  end

  describe "when no subscription exists for the customer ID" do
    it "returns a failure with :user_not_found" do
      stripe_sub = build_stripe_sub(price_id: nil)
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
      stripe_sub = build_stripe_sub(price_id: "price_monthly_test")
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.plan).to eq("pro_monthly")
    end

    it "sets plan to pro_yearly when price_id matches stripe_price_pro_yearly" do
      stripe_sub = build_stripe_sub(price_id: "price_yearly_test")
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.plan).to eq("pro_yearly")
    end

    it "sets plan to free when price_id does not match any known price" do
      stripe_sub = build_stripe_sub(price_id: "price_unknown")
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.plan).to eq("free")
    end
  end

  describe "time conversion" do
    before do
      create(:subscription, user:, stripe_customer_id: "cus_test")
    end

    it "sets cancel_at to nil when Stripe returns nil" do
      stripe_sub = build_stripe_sub(price_id: nil, cancel_at: nil)
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.cancel_at).to be_nil
    end

    it "converts a unix timestamp to a Time when cancel_at is present" do
      future_ts = 30.days.from_now.to_i
      stripe_sub = build_stripe_sub(price_id: nil, cancel_at: future_ts)
      call(stripe_subscription: stripe_sub, stripe_customer_id: "cus_test")
      expect(user.reload.subscription.cancel_at).to be_within(1.second).of(Time.zone.at(future_ts))
    end
  end
end
