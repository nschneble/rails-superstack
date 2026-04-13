module SystemTestHelpers
  include ActionView::RecordIdentifier

  # Signs in via the Passwordless magic link confirm path. The standard
  # passwordless_sign_in(user) method from passwordless/test_helpers
  # manipulates the Rack environment directly and does not work in
  # browser-based (Capybara) tests.

  def sign_in_as(user)
    session = user.passwordless_sessions.create!
    visit confirm_auth_sign_in_path(session, session.token)
  end
end

RSpec.configure do |config|
  config.include SystemTestHelpers, type: :system
end
