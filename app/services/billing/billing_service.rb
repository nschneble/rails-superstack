class Billing::BillingService < BaseService
  private

  def stripe_client
    @stripe_client ||= Stripe::StripeClient.new(Figaro.env.stripe_secret_key)
  end
end
