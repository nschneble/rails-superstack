require "rails_helper"

RSpec.describe Billing::Webhooks::CheckoutCompleteHandler, type: :service do
  include_context "with stubbed Stripe client"

  def call(payload)
    described_class.call(payload:)
  end

  describe "subscription mode" do
    let(:user) { create(:user) }

    before do
      create(:subscription, user:, stripe_customer_id: "cus_sub_test")

      # rubocop:disable RSpec/VerifiedDoubles
      fake_stripe_sub = double(
        "Stripe::Subscription",
        id: "sub_test",
        status: "active",
        items: double("items", data: [
          double("item", price: double("price", id: nil))
        ])
      )
      # rubocop:enable RSpec/VerifiedDoubles
      allow(fake_stripe_sub).to receive(:[]).with("cancel_at").and_return(nil)
      allow(fake_stripe_sub).to receive(:[]).with("current_period_end").and_return(30.days.from_now.to_i)
      allow(fake_stripe_sub).to receive(:[]).with("trial_end").and_return(nil)
      allow(fake_subscriptions).to receive(:retrieve).with("sub_test").and_return(fake_stripe_sub)
    end

    it "returns success" do
      payload = { "data" => { "object" => { "mode" => "subscription", "subscription" => "sub_test", "customer" => "cus_sub_test" } } }
      expect(call(payload)).to be_success
    end

    it "upserts the subscription" do
      payload = { "data" => { "object" => { "mode" => "subscription", "subscription" => "sub_test", "customer" => "cus_sub_test" } } }
      call(payload)
      expect(user.reload.subscription.stripe_subscription_id).to eq("sub_test")
    end
  end

  describe "payment mode" do
    let(:user) { create(:user) }

    it "delegates to CompletePurchaseService and returns success" do
      create(:demo_theme_purchase, user:, stripe_checkout_session_id: "cs_payment_test")

      payload = { "data" => { "object" => { "id" => "cs_payment_test", "mode" => "payment", "payment_intent" => "pi_test123" } } }
      expect(call(payload)).to be_success
    end
  end

  describe "unrecognized mode" do
    it "returns success with nil" do
      payload = { "data" => { "object" => { "mode" => "setup" } } }
      result = call(payload)
      expect(result).to be_success
      expect(result.payload).to be_nil
    end
  end
end
