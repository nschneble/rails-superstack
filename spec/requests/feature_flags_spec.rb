require 'rails_helper'

RSpec.describe "Flipper feature flags", type: :request do
  it "redirects anonymous users to sign in with an alert" do
    get "/flipper"

    expect(response).to redirect_to(auth_sign_in_path)
    expect(flash[:alert]).to eq("You must be logged in to visit this page")
  end

  it "redirects non-admin users to the homepage with an alert" do
    user = create(:user)

    passwordless_sign_in(user)
    get "/flipper"

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("You are not authorized to access this page")
  end

  it "allows admin users to view the Flipper UI" do
    admin = create(:user, :admin)

    passwordless_sign_in(admin)
    get "/flipper"

    expect(response).to redirect_to("/flipper/features")
    follow_redirect!

    expect(response).to have_http_status(:ok)
  end
end
