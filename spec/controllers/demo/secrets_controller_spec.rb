require "rails_helper"

RSpec.describe Demo::SecretsController, type: :controller do
  include Passwordless::TestHelpers
  include_context "with demo routes"

  describe "GET #sssh" do
    context "when the :secrets flag is disabled" do
      before { Flipper.disable(:secrets) }
      after  { Flipper.disable(:secrets) }

      it "raises a routing error" do
        expect { get :sssh }.to raise_error(ActionController::RoutingError)
      end
    end

    context "when the :secrets flag is enabled for the user" do
      after { Flipper.disable(:secrets) }

      it "returns ok" do
        user = create(:user)
        Flipper.enable_actor(:secrets, user)
        passwordless_sign_in(user)

        get :sssh
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
