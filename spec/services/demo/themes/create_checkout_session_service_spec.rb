require "rails_helper"

RSpec.describe Demo::Themes::CreateCheckoutSessionService, type: :service do
  include_context "with stubbed Stripe client"
  let(:user) { create(:user) }
  let(:fake_session) do
    instance_double(Stripe::Checkout::Session, id: "cs_theme_test", url: "https://checkout.stripe.com/theme")
  end

  let(:call_args) do
    {
      user:,
      theme_key: "midnight_galaxy",
      success_url: "https://example.com/success",
      cancel_url: "https://example.com/cancel"
    }
  end

  before do
    allow(fake_checkout_sessions).to receive(:create).and_return(fake_session)
  end

  describe "success" do
    it "returns a successful result with the session" do
      result = described_class.call(**call_args)
      expect(result).to be_success
      expect(result.payload).to eq(fake_session)
    end

    it "creates a pending Demo::Themes::ThemePurchase record" do
      expect { described_class.call(**call_args) }
        .to change { Demo::Themes::ThemePurchase.pending.count }.by(1)
    end

    it "stores the checkout session ID on the purchase" do
      described_class.call(**call_args)
      purchase = Demo::Themes::ThemePurchase.last
      expect(purchase.stripe_checkout_session_id).to eq("cs_theme_test")
    end

    it "creates the Stripe session with mode: payment" do
      expect(fake_checkout_sessions).to receive(:create).with(
        hash_including(mode: "payment")
      ).and_return(fake_session)
      described_class.call(**call_args)
    end

    it "creates the Stripe session with the correct unit amount" do
      expect(fake_checkout_sessions).to receive(:create) do |params|
        amount = params.dig(:line_items, 0, :price_data, :unit_amount)
        expect(amount).to eq(1499)
        fake_session
      end
      described_class.call(**call_args)
    end
  end

  describe "invalid theme" do
    it "returns failure with :invalid_theme" do
      result = described_class.call(**call_args.merge(theme_key: "nonexistent"))
      expect(result).to be_failure
      expect(result.error).to eq(:invalid_theme)
    end
  end

  describe "already purchased" do
    it "returns failure with :already_purchased" do
      create(:demo_theme_purchase, user:, theme_key: "midnight_galaxy", status: :completed)

      result = described_class.call(**call_args)
      expect(result).to be_failure
      expect(result.error).to eq(:already_purchased)
    end

    it "allows a new purchase if the previous attempt was pending" do
      create(:demo_theme_purchase, user:, theme_key: "midnight_galaxy", status: :pending)

      result = described_class.call(**call_args)
      expect(result).to be_success
    end
  end

  describe "on Stripe error" do
    it "marks the purchase as failed and returns failure" do
      allow(fake_checkout_sessions).to receive(:create)
        .and_raise(Stripe::StripeError.new("Test error"))

      result = described_class.call(**call_args)
      expect(result).to be_failure
      expect(result.error).to eq(:stripe_error)
      expect(Demo::Themes::ThemePurchase.last.status).to eq("failed")
    end
  end
end
