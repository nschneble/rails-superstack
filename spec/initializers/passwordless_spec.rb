require "rails_helper"

RSpec.describe Passwordless do
  describe "#after_session_confirm hook" do
    it "records the login on the authenticatable user" do
      user = create(:user)
      request = instance_double(ActionDispatch::Request, remote_ip: "127.0.0.1")
      session = instance_double(Passwordless::Session, authenticatable: user)

      allow(user).to receive(:record_passwordless_login!)

      described_class.config.after_session_confirm.call(session, request)

      expect(user).to have_received(:record_passwordless_login!).with(request)
    end
  end
end
