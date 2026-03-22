require "rails_helper"

RSpec.describe "Billing::Webhooks", type: :request do
  let(:signing_secret) { "whsec_test_secret_key_for_specs" }
  let(:payload) do
    {
      id: "evt_test_#{SecureRandom.hex(8)}",
      type: "customer.subscription.updated",
      data: { object: {} }
    }.to_json
  end
  let(:timestamp) { Time.current.to_i }
  let(:signed_payload) { "#{timestamp}.#{payload}" }
  let(:signature) { OpenSSL::HMAC.hexdigest("SHA256", signing_secret, signed_payload) }
  let(:stripe_signature) { "t=#{timestamp},v1=#{signature}" }

  before do
    allow(Figaro.env).to receive(:stripe_signing_secret).and_return(signing_secret)
  end

  describe "POST /webhooks/stripe" do
    context "with a valid signature" do
      before do
        allow(Billing::ProcessWebhookEventService).to receive(:call).and_return(
          ServiceResult.ok(build(:webhook_event))
        )
      end

      it "returns 200" do
        post stripe_webhook_path,
          params: payload,
          headers: {
            "Content-Type" => "application/json",
            "Stripe-Signature" => stripe_signature
          }

        expect(response).to have_http_status(:ok)
      end

      it "calls the process service with parsed event data" do
        expect(Billing::ProcessWebhookEventService).to receive(:call).and_return(
          ServiceResult.ok(build(:webhook_event))
        )

        post stripe_webhook_path,
          params: payload,
          headers: {
            "Content-Type" => "application/json",
            "Stripe-Signature" => stripe_signature
          }
      end
    end

    context "with an invalid signature" do
      it "returns 400" do
        post stripe_webhook_path,
          params: payload,
          headers: {
            "Content-Type" => "application/json",
            "Stripe-Signature" => "t=#{timestamp},v1=badsignature"
          }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with a processing failure" do
      before do
        allow(Billing::ProcessWebhookEventService).to receive(:call).and_return(
          ServiceResult.fail(:processing_failed)
        )
      end

      it "returns 422" do
        post stripe_webhook_path,
          params: payload,
          headers: {
            "Content-Type" => "application/json",
            "Stripe-Signature" => stripe_signature
          }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
