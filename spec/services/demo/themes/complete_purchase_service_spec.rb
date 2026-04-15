require "rails_helper"

RSpec.describe Demo::Themes::CompletePurchaseService, type: :service do
  describe "success" do
    it "marks the purchase as completed and stores the payment intent id" do
      purchase = create(:demo_theme_purchase, stripe_checkout_session_id: "cs_test")

      result = described_class.call(session: { "id" => "cs_test", "payment_intent" => "pi_test" })

      expect(result).to be_success
      expect(purchase.reload.status).to eq("completed")
      expect(purchase.stripe_payment_intent_id).to eq("pi_test")
    end
  end

  describe "failure" do
    it "returns purchase_not_found when the checkout session is unknown" do
      result = described_class.call(session: { "id" => "missing", "payment_intent" => "pi_test" })

      expect(result).to be_failure
      expect(result.error).to eq(:purchase_not_found)
    end

    it "returns record_invalid when the update fails" do
      purchase = create(:demo_theme_purchase, stripe_checkout_session_id: "cs_invalid")
      allow(Demo::Themes::ThemePurchase).to receive(:find_by).and_return(purchase)
      allow(purchase).to receive(:update!).and_raise(
        ActiveRecord::RecordInvalid.new(Demo::Themes::ThemePurchase.new)
      )

      result = described_class.call(session: { "id" => "cs_invalid", "payment_intent" => "pi_test" })

      expect(result).to be_failure
      expect(result.error).to eq(:record_invalid)
    end
  end
end
