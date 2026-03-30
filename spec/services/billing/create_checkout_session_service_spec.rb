require "rails_helper"

RSpec.describe Billing::CreateCheckoutSessionService, type: :service do
  include_context "with stubbed Stripe client"
  let(:user) { create(:user) }
  let(:fake_session) { instance_double(Stripe::Checkout::Session, url: "https://checkout.stripe.com/test") }
  let(:fake_customer) { instance_double(Stripe::Customer, id: "cus_test123") }

  let(:call_args) do
    {
      user:,
      price_id: "price_test",
      success_url: "https://example.com/success",
      cancel_url: "https://example.com/cancel"
    }
  end

  before do
    allow(fake_customers).to receive(:create).and_return(fake_customer)
    allow(fake_checkout_sessions).to receive(:create).and_return(fake_session)
  end

  describe "success" do
    it "returns a successful result with the session" do
      result = described_class.call(**call_args)
      expect(result).to be_success
      expect(result.payload).to eq(fake_session)
    end

    it "creates a Stripe customer for a new user" do
      described_class.call(**call_args)
      expect(fake_customers).to have_received(:create).with(email: user.email)
    end

    it "persists the stripe_customer_id to a subscription record" do
      described_class.call(**call_args)
      expect(user.reload.stripe_customer_id).to eq("cus_test123")
    end

    it "does not create a duplicate Stripe customer when one exists" do
      create(:subscription, user:, stripe_customer_id: "cus_existing")
      described_class.call(**call_args)
      expect(fake_customers).not_to have_received(:create)
    end

    it "offers a 7-day trial for users with no prior subscription" do
      described_class.call(**call_args)
      expect(fake_checkout_sessions).to have_received(:create).with(
        hash_including(subscription_data: { trial_period_days: 7 })
      )
    end

    it "offers a trial when a subscription exists but checkout was never completed" do
      create(:subscription, user:, stripe_customer_id: "cus_existing", status: :incomplete, stripe_subscription_id: nil)
      described_class.call(**call_args)
      expect(fake_checkout_sessions).to have_received(:create).with(
        hash_including(subscription_data: { trial_period_days: 7 })
      )
    end

    it "does not offer a trial when a real subscription has been completed" do
      create(:subscription, user:, stripe_customer_id: "cus_existing", stripe_subscription_id: "sub_abc123")
      described_class.call(**call_args)
      expect(fake_checkout_sessions).to have_received(:create).with(
        hash_excluding(:subscription_data)
      )
    end
  end

  describe "failure" do
    it "returns a failure result on Stripe::StripeError" do
      allow(fake_customers).to receive(:create).and_raise(Stripe::StripeError.new("Card declined"))

      result = described_class.call(**call_args)
      expect(result).to be_failure
      expect(result.error).to eq(:stripe_error)
    end
  end
end
