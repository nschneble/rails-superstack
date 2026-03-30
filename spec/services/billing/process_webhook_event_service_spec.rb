require "rails_helper"

RSpec.describe Billing::ProcessWebhookEventService, type: :service do
  include_context "with stubbed Stripe client"
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

  describe "race condition: RecordNotUnique on save" do
    it "returns success by finding the existing event" do
      # Simulate a concurrent request having already saved this event
      existing = create(:webhook_event, stripe_event_id:, event_type: "payment_intent.created", status: :ignored)
      new_event = WebhookEvent.new
      allow(WebhookEvent).to receive(:find_or_initialize_by).with(stripe_event_id:).and_return(new_event)
      allow(new_event).to receive(:save!).and_raise(ActiveRecord::RecordNotUnique)

      result = call(event_type: "payment_intent.created", payload: {})
      expect(result).to be_success
      expect(result.payload).to eq(existing)
    end
  end

  describe "handler returns a failure result" do
    it "marks the event as failed and returns failure" do
      allow(Billing::Webhooks::SubscriptionChangeHandler).to receive(:call).and_return(
        ServiceResult.fail(:subscription_not_found)
      )

      result = call(event_type: "customer.subscription.deleted", payload: { "data" => { "object" => {} } })

      expect(result).to be_failure
      event = WebhookEvent.find_by(stripe_event_id:)
      expect(event.status).to eq("failed")
      expect(event.error_message).to eq("subscription_not_found")
    end
  end

  describe "unexpected error during handler execution" do
    let(:user) { create(:user) }

    before do
      create(:subscription, user:, stripe_customer_id: "cus_err_test")
      allow(Billing::Webhooks::SubscriptionChangeHandler).to receive(:call).and_raise(RuntimeError, "boom")
    end

    it "marks the event as failed and re-raises the error" do
      payload = {
        "data" => {
          "object" => {
            "id" => "sub_err",
            "customer" => "cus_err_test",
            "status" => "active",
            "cancel_at" => nil,
            "current_period_end" => 30.days.from_now.to_i,
            "trial_end" => nil,
            "items" => { "data" => [ { "price" => { "id" => nil } } ] }
          }
        }
      }

      expect {
        call(event_type: "customer.subscription.updated", payload:)
      }.to raise_error(RuntimeError, "boom")

      event = WebhookEvent.find_by(stripe_event_id:)
      expect(event.status).to eq("failed")
      expect(event.error_message).to eq("boom")
    end
  end

  describe "customer.subscription.updated" do
    let(:user) { create(:user) }
    let(:fake_sub_data) do
      {
        "id" => "sub_updated",
        "status" => "active",
        "customer" => "cus_update_test",
        "cancel_at" => nil,
        "current_period_end" => 30.days.from_now.to_i,
        "trial_end" => nil,
        "items" => { "data" => [ { "price" => { "id" => nil } } ] }
      }
    end

    before do
      create(:subscription, user:, stripe_customer_id: "cus_update_test")

      # rubocop:disable RSpec/VerifiedDoubles
      fake_sub_updated = double(
        "Stripe::Subscription",
        id: "sub_updated",
        status: "active",
        items: double("items", data: [
          double("item", price: double("price", id: nil))
        ])
      )
      # rubocop:enable RSpec/VerifiedDoubles
      allow(fake_sub_updated).to receive(:[]).with("cancel_at").and_return(nil)
      allow(fake_sub_updated).to receive(:[]).with("current_period_end").and_return(30.days.from_now.to_i)
      allow(fake_sub_updated).to receive(:[]).with("trial_end").and_return(nil)
      allow(fake_subscriptions).to receive(:retrieve).with("sub_updated").and_return(fake_sub_updated)
    end

    it "upserts the subscription and marks event as processed" do
      payload = { "data" => { "object" => fake_sub_data } }
      result = call(event_type: "customer.subscription.updated", payload:)

      expect(result).to be_success
      expect(WebhookEvent.find_by(stripe_event_id:).status).to eq("processed")
    end
  end
end
