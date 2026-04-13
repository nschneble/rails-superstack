# Syncs a Stripe subscription object into a local database Subscription

class Billing::UpsertSubscriptionService < BaseService
  def call(stripe_subscription:, stripe_customer_id:)
    @user = Subscription.find_by(stripe_customer_id:)&.user
    return ServiceResult.fail(:user_not_found) unless @user

    subscription.update!(StripeSubscriptionParser.call(stripe_subscription))
    ServiceResult.ok(subscription)
  rescue StripeSubscriptionParser::UnknownPriceError => error
    log_error_and_fail(:unknown_price_id, error.message)
  end

  private

  def subscription
    @subscription ||= @user.subscription.presence || @user.build_subscription
  end
end
