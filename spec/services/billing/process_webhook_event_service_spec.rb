require "rails_helper"

RSpec.describe Billing::ProcessWebhookEventService, type: :service do
  include_context "with stubbed stripe client"
  let(:stripe_event_id) { "evt_#{SecureRandom.hex(8)}" }

  def call(event_type:, payload:)
    described_class.call(stripe_event_id:, event_type:, payload:)
  end

  describe "deduplication" do
    it "returns success without reprocessing an already-processed event" do
      create(:webhook_event, stripe_event_id:, event_type: "customer.subscription.updated", status: :processed)

      result = call(event_type: "customer.subscription.updated", payload: {})
      expect(result).to be_success
      expect(WebhookEvent.where(stripe_event_id:).count).to eq(1)
    end
  end

  describe "ignored events" do
    it "marks unhandled event types as ignored" do
      result = call(
        event_type: "payment_intent.created",
        payload: { "data" => { "object" => {} } }
      )

      expect(result).to be_success
      event = WebhookEvent.find_by(stripe_event_id:)
      expect(event.status).to eq("ignored")
    end
  end

  describe "checkout.session.completed with subscription mode" do
    let(:user) { create(:user) }

    before do
      create(:subscription, user:, stripe_customer_id: "cus_sub_test")

      fake_stripe_sub = double(
        "Stripe::Subscription",
        id: "sub_test",
        status: "active",
        cancel_at: nil,
        current_period_end: 30.days.from_now.to_i,
        trial_end: nil,
        items: double("items", data: [
          double("item", price: double("price", id: nil))
        ])
      )
      allow(fake_subscriptions).to receive(:retrieve).with("sub_test").and_return(fake_stripe_sub)
    end

    it "marks the event as processed" do
      payload = {
        "data" => {
          "object" => {
            "mode" => "subscription",
            "subscription" => "sub_test",
            "customer" => "cus_sub_test"
          }
        }
      }

      result = call(event_type: "checkout.session.completed", payload:)
      expect(result).to be_success
      expect(WebhookEvent.find_by(stripe_event_id:).status).to eq("processed")
    end

    it "updates the subscription record" do
      payload = {
        "data" => {
          "object" => {
            "mode" => "subscription",
            "subscription" => "sub_test",
            "customer" => "cus_sub_test"
          }
        }
      }

      call(event_type: "checkout.session.completed", payload:)
      expect(user.reload.subscription.stripe_subscription_id).to eq("sub_test")
    end
  end

  describe "checkout.session.completed with payment mode" do
    let(:user) { create(:user) }

    it "completes the demo theme purchase" do
      purchase = create(:demo_theme_purchase, user:, stripe_checkout_session_id: "cs_payment_test")

      payload = {
        "data" => {
          "object" => {
            "id" => "cs_payment_test",
            "mode" => "payment",
            "payment_intent" => "pi_test123"
          }
        }
      }

      result = call(event_type: "checkout.session.completed", payload:)
      expect(result).to be_success
      expect(purchase.reload.status).to eq("completed")
      expect(purchase.reload.stripe_payment_intent_id).to eq("pi_test123")
    end
  end

  describe "customer.subscription.updated" do
    let(:user) { create(:user) }

    before do
      create(:subscription, user:, stripe_customer_id: "cus_update_test")
    end

    it "upserts the subscription and marks event as processed" do
      fake_sub_data = {
        "id" => "sub_updated",
        "status" => "active",
        "customer" => "cus_update_test",
        "cancel_at" => nil,
        "current_period_end" => 30.days.from_now.to_i,
        "trial_end" => nil,
        "items" => { "data" => [ { "price" => { "id" => nil } } ] }
      }

      allow(fake_subscriptions).to receive(:retrieve).with("sub_updated").and_return(
        double(
          "Stripe::Subscription",
          id: "sub_updated",
          status: "active",
          cancel_at: nil,
          current_period_end: 30.days.from_now.to_i,
          trial_end: nil,
          items: double("items", data: [
            double("item", price: double("price", id: nil))
          ])
        )
      )

      payload = { "data" => { "object" => fake_sub_data } }
      result = call(event_type: "customer.subscription.updated", payload:)

      expect(result).to be_success
      expect(WebhookEvent.find_by(stripe_event_id:).status).to eq("processed")
    end
  end
end
