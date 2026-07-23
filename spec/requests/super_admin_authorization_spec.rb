require "rails_helper"

RSpec.describe "SuperAdmin authorization", type: :request do
  it "denies a non-admin authenticated user" do
    user = create(:user)
    passwordless_sign_in(user)

    get "/admin/users"

    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(flash[:alert]).to be_present
  end

  it "allows an admin user" do
    admin = create(:user, :admin)
    passwordless_sign_in(admin)

    get "/admin/users"

    expect(response).to have_http_status(:ok)
  end
end
