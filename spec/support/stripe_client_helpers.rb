RSpec.shared_context "with Stripe subscription builder" do
  # rubocop:disable RSpec/VerifiedDoubles
  def build_stripe_subscription(price_id:, cancel_at: nil, current_period_end: nil, trial_end: nil)
    sub = double(
      "Stripe::Subscription",
      id: "sub_test",
      status: "active",
      items: double("items", data: [
        double("item", price: double("price", id: price_id))
      ])
    )
    allow(sub).to receive(:[]).with("cancel_at").and_return(cancel_at)
    allow(sub).to receive(:[]).with("current_period_end").and_return(current_period_end)
    allow(sub).to receive(:[]).with("trial_end").and_return(trial_end)
    sub
  end
  # rubocop:enable RSpec/VerifiedDoubles
end

RSpec.shared_context "with stubbed Stripe client" do
  let(:fake_subscriptions)     { instance_double(Stripe::SubscriptionService) }
  let(:fake_customers)         { instance_double(Stripe::CustomerService) }
  let(:fake_checkout_sessions) { instance_double(Stripe::Checkout::SessionService) }
  let(:fake_portal_sessions)   { instance_double(Stripe::BillingPortal::SessionService) }

  before do
    fake_stripe_client = instance_double(Stripe::StripeClient)
    fake_v1 = instance_double(Stripe::V1Services)
    fake_checkout = instance_double(Stripe::CheckoutService)
    fake_billing_portal = instance_double(Stripe::BillingPortalService)

    allow(Stripe::StripeClient).to receive(:new).and_return(fake_stripe_client)
    allow(fake_stripe_client).to receive(:v1).and_return(fake_v1)
    allow(fake_checkout).to receive(:sessions).and_return(fake_checkout_sessions)
    allow(fake_v1).to receive_messages(subscriptions: fake_subscriptions, customers: fake_customers, checkout: fake_checkout, billing_portal: fake_billing_portal)
    allow(fake_billing_portal).to receive(:sessions).and_return(fake_portal_sessions)
  end
end
