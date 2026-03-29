RSpec.shared_context "with stubbed Stripe client" do
  let(:fake_stripe_client)     { instance_double(Stripe::StripeClient) }
  let(:fake_v1)                { instance_double(Stripe::V1Services) }
  let(:fake_subscriptions)     { instance_double(Stripe::SubscriptionService) }
  let(:fake_customers)         { instance_double(Stripe::CustomerService) }
  let(:fake_checkout)          { instance_double(Stripe::CheckoutService) }
  let(:fake_checkout_sessions) { instance_double(Stripe::Checkout::SessionService) }
  let(:fake_billing_portal)    { instance_double(Stripe::BillingPortalService) }
  let(:fake_portal_sessions)   { instance_double(Stripe::BillingPortal::SessionService) }

  before do
    allow(Stripe::StripeClient).to receive(:new).and_return(fake_stripe_client)
    allow(fake_stripe_client).to receive(:v1).and_return(fake_v1)
    allow(fake_v1).to receive(:subscriptions).and_return(fake_subscriptions)
    allow(fake_v1).to receive(:customers).and_return(fake_customers)
    allow(fake_v1).to receive(:checkout).and_return(fake_checkout)
    allow(fake_checkout).to receive(:sessions).and_return(fake_checkout_sessions)
    allow(fake_v1).to receive(:billing_portal).and_return(fake_billing_portal)
    allow(fake_billing_portal).to receive(:sessions).and_return(fake_portal_sessions)
  end
end
