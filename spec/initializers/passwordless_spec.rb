require "rails_helper"

RSpec.describe "Passwordless after_session_confirm hook" do
  it "records the login on the authenticatable user" do
    user = create(:user)
    request = instance_double("ActionDispatch::Request", remote_ip: "127.0.0.1")
    session = instance_double("Passwordless::Session", authenticatable: user)

    expect(user).to receive(:record_passwordless_login!).with(request)

    Passwordless.config.after_session_confirm.call(session, request)
  end
end
