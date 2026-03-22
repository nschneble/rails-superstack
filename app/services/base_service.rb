class BaseService
  def self.call(...) = new.call(...)

  def call(*)
    raise NotImplementedError, I18n.t("errors.method_not_implemented")
  end

  private

  def stripe_client
    @stripe_client ||= Stripe::StripeClient.new(Figaro.env.stripe_secret_key)
  end
end
