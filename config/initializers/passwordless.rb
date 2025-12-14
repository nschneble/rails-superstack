Passwordless.configure do |config|
  config.default_from_address = "no-reply@passwordless.github"
  config.restrict_token_reuse = true

  config.expires_at = lambda { 3.months.from_now }
  config.timeout_at = lambda { 10.minutes.from_now }

  config.after_session_confirm = ->(session, request) do
    user = session.authenticatable
    return unless user

    user.record_passwordless_login!(request)
  end
end
