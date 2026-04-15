require "rails_helper"

RSpec.describe "Passwordless sessions", type: :request do
  it "redirects signed-in users from sign-in form to application root" do
    user = create(:user)
    passwordless_sign_in(user)

    get auth_sign_in_path, headers: { HTTP_REFERER: auth_sign_in_path }

    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("You're already signed in, sillypants")
  end

  it "redirects signed-in users from verification screen to application root" do
    user = create(:user)
    passwordless_sign_in(user)
    passwordless_session = Passwordless::Session.create!(authenticatable: user)

    get verify_auth_sign_in_path(id: passwordless_session.identifier),
      headers: { HTTP_REFERER: auth_sign_in_path }

    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to eq("You're already signed in, sillypants")
  end

  it "allows signed-in users to process a magic link token without blocking them" do
    user = create(:user)
    passwordless_sign_in(user)
    passwordless_session = Passwordless::Session.create!(authenticatable: user)

    get confirm_auth_sign_in_path(id: passwordless_session.identifier, token: passwordless_session.token)

    expect(flash[:notice]).not_to eq("You're already signed in, sillypants")
  end

  it "does not treat bearer token authentication as an existing passwordless session" do
    user = create(:user)
    token = ApiToken.issue!(user:, name: "Spec Token")

    get auth_sign_in_path,
      headers: {
        HTTP_REFERER: auth_sign_in_path,
        Authorization: "Bearer #{token.plaintext_token}"
      }

    expect(response).to have_http_status(:ok)
    expect(flash[:notice]).to be_nil
  end

  it "creates a new user when the email does not exist" do
    expect {
      post sign_in_path, params: { passwordless: { email: "brandnew@example.com" } }
    }.to change(User, :count).by(1)
  end

  it "does not create a duplicate user when the email already exists" do
    create(:user, email: "existing@example.com")
    expect {
      post sign_in_path, params: { passwordless: { email: "existing@example.com" } }
    }.not_to change(User, :count)
  end
end
