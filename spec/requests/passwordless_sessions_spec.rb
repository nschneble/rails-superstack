require "rails_helper"

RSpec.describe "Passwordless sessions", type: :request do
  it "redirects signed-in users from sign-in form to application root" do
    user = create(:user)
    passwordless_sign_in(user)

    get auth_sign_in_path, headers: { "HTTP_REFERER" => auth_sign_in_path }

    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("You're already signed in, sillypants")
  end

  it "redirects signed-in users from verification screen to application root" do
    user = create(:user)
    passwordless_sign_in(user)
    passwordless_session = Passwordless::Session.create!(authenticatable: user)

    get verify_auth_sign_in_path(id: passwordless_session.identifier),
      headers: { "HTTP_REFERER" => auth_sign_in_path }

    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("You're already signed in, sillypants")
  end
end
