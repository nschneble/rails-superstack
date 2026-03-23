require "rails_helper"

RSpec.describe "Billing::Checkout", type: :request do
  describe "POST /billing/checkout" do
    it "requires authentication" do
      post billing_checkout_path, params: { price_id: "price_test" }
      expect(response).to redirect_to(auth_sign_in_path)
    end

    it "redirects to Stripe checkout on success" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Billing::CreateCheckoutSessionService).to receive(:call).and_return(
        ServiceResult.ok(instance_double(Stripe::Checkout::Session, url: "https://checkout.stripe.com/test"))
      )

      post billing_checkout_path, params: { price_id: "price_test" }
      expect(response).to redirect_to("https://checkout.stripe.com/test")
    end

    it "redirects to plans with alert on service failure" do
      user = create(:user)
      passwordless_sign_in(user)

      allow(Billing::CreateCheckoutSessionService).to receive(:call).and_return(
        ServiceResult.fail(:stripe_error)
      )

      post billing_checkout_path, params: { price_id: "price_test" }
      expect(response).to redirect_to(billing_plans_path)
    end

    it "redirects to plans with alert when price_id is blank" do
      user = create(:user)
      passwordless_sign_in(user)

      post billing_checkout_path, params: { price_id: "" }
      expect(response).to redirect_to(billing_plans_path)
    end
  end

  describe "GET /billing/checkout/success" do
    it "requires authentication" do
      get billing_checkout_success_path
      expect(response).to redirect_to(auth_sign_in_path)
    end

    it "renders the success page for authenticated users" do
      user = create(:user)
      passwordless_sign_in(user)
      get billing_checkout_success_path
      expect(response).to have_http_status(:ok)
    end
  end
end
