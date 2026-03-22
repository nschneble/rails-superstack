require "rails_helper"

RSpec.describe Billing::CreatePortalSessionService, type: :service do
  let(:return_url) { "https://example.com/settings" }
  let(:fake_session) { instance_double(Stripe::BillingPortal::Session, url: "https://billing.stripe.com/portal") }

  describe "with a customer" do
    let(:user) { create(:user) }

    before do
      create(:subscription, user:, stripe_customer_id: "cus_portal_test")
      allow(Stripe::BillingPortal::Session).to receive(:create).and_return(fake_session)
    end

    it "returns a successful result with the portal session" do
      result = described_class.call(user: user.reload, return_url:)
      expect(result).to be_success
      expect(result.payload).to eq(fake_session)
    end

    it "creates the portal session with the correct customer ID" do
      expect(Stripe::BillingPortal::Session).to receive(:create).with(
        hash_including(customer: "cus_portal_test")
      ).and_return(fake_session)
      described_class.call(user: user.reload, return_url:)
    end
  end

  describe "without a customer" do
    let(:user) { create(:user) }

    it "returns a failure with :no_customer" do
      result = described_class.call(user:, return_url:)
      expect(result).to be_failure
      expect(result.error).to eq(:no_customer)
    end
  end

  describe "on Stripe error" do
    let(:user) { create(:user) }

    before do
      create(:subscription, user:, stripe_customer_id: "cus_error_test")
      allow(Stripe::BillingPortal::Session).to receive(:create)
        .and_raise(Stripe::StripeError.new("Invalid customer"))
    end

    it "returns a failure result" do
      result = described_class.call(user: user.reload, return_url:)
      expect(result).to be_failure
      expect(result.error).to eq(:stripe_error)
    end
  end
end
