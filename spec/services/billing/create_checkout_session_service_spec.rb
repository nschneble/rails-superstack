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
      expect(fake_customers).to receive(:create).with(email: user.email).and_return(fake_customer)
      described_class.call(**call_args)
    end

    it "persists the stripe_customer_id to a subscription record" do
      described_class.call(**call_args)
      expect(user.reload.stripe_customer_id).to eq("cus_test123")
    end

    it "does not create a duplicate Stripe customer when one exists" do
      create(:subscription, user:, stripe_customer_id: "cus_existing")
      expect(fake_customers).not_to receive(:create)
      described_class.call(**call_args)
    end

    it "offers a 7-day trial for users with no prior subscription" do
      expect(fake_checkout_sessions).to receive(:create).with(
        hash_including(subscription_data: { trial_period_days: 7 })
      ).and_return(fake_session)
      described_class.call(**call_args)
    end

    it "offers a trial when a subscription exists but checkout was never completed" do
      create(:subscription, user:, stripe_customer_id: "cus_existing", status: :incomplete, stripe_subscription_id: nil)
      expect(fake_checkout_sessions).to receive(:create).with(
        hash_including(subscription_data: { trial_period_days: 7 })
      ).and_return(fake_session)
      described_class.call(**call_args)
    end

    it "does not offer a trial when a real subscription has been completed" do
      create(:subscription, user:, stripe_customer_id: "cus_existing", stripe_subscription_id: "sub_abc123")
      expect(fake_checkout_sessions).to receive(:create) do |params|
        expect(params).not_to have_key(:subscription_data)
        fake_session
      end
      described_class.call(**call_args)
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
