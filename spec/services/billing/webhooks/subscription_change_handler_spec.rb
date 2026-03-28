require "rails_helper"

RSpec.describe Billing::Webhooks::SubscriptionChangeHandler, type: :service do
  include_context "with stubbed stripe client"

  def call(payload)
    described_class.call(payload:)
  end

  let(:user) { create(:user) }

  before do
    create(:subscription, user:, stripe_customer_id: "cus_update_test")

    fake_stripe_sub = double(
      "Stripe::Subscription",
      id: "sub_updated",
      status: "active",
      items: double("items", data: [
        double("item", price: double("price", id: nil))
      ])
    )
    allow(fake_stripe_sub).to receive(:[]).with("cancel_at").and_return(nil)
    allow(fake_stripe_sub).to receive(:[]).with("current_period_end").and_return(30.days.from_now.to_i)
    allow(fake_stripe_sub).to receive(:[]).with("trial_end").and_return(nil)
    allow(fake_subscriptions).to receive(:retrieve).with("sub_updated").and_return(fake_stripe_sub)
  end

  it "upserts the subscription and returns success" do
    payload = { "data" => { "object" => { "id" => "sub_updated", "customer" => "cus_update_test" } } }

    result = call(payload)
    expect(result).to be_success
    expect(user.reload.subscription.stripe_subscription_id).to eq("sub_updated")
  end
end
