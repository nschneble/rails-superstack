require "rails_helper"

RSpec.describe "API tokens", type: :request do
  describe "GET /settings" do
    it "redirects to the profile settings route" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_root_path

      expect(response).to redirect_to(settings_profile_path)
    end
  end

  describe "POST /settings/api_token" do
    it "requires authentication" do
      post settings_create_api_token_path, params: { api_token: { name: "Spec Token" } }

      expect(response).to redirect_to(auth_sign_in_path)
      expect(flash[:alert]).to eq("You must be logged in to visit this page")
    end

    it "creates a token for the current user and shows plaintext once" do
      user = create(:user)
      passwordless_sign_in(user)

      expect do
        post settings_create_api_token_path, params: { api_token: { name: "Spec Token" } }
      end.to change(user.api_tokens, :count).by(1)

      expect(response).to redirect_to(settings_api_path)
      expect(flash[:notice]).to eq("API token created")

      plaintext = session[:api_token_plaintext]
      expect(plaintext).to be_present

      follow_redirect!
      expect(response.body).to include("API tokens")
      expect(response.body).to include("Spec Token")
      expect(response.body).to include("Bearer #{plaintext}")

      get settings_api_path
      expect(response.body).not_to include("Bearer #{plaintext}")
    end

    it "does not create a token with a blank name" do
      user = create(:user)
      passwordless_sign_in(user)

      expect do
        post settings_create_api_token_path, params: { api_token: { name: " " } }
      end.not_to change(user.api_tokens, :count)

      expect(response).to redirect_to(settings_api_path)
      expect(flash[:alert]).to include("Name can't be blank")
    end
  end

  describe "DELETE /settings/api_token/:id" do
    it "requires authentication" do
      token = create(:api_token)

      delete settings_delete_api_token_path(token)

      expect(response).to redirect_to(auth_sign_in_path)
      expect(flash[:alert]).to eq("You must be logged in to visit this page")
    end

    it "revokes an active token owned by the current user" do
      user = create(:user)
      token = create(:api_token, user:, revoked_at: nil)
      passwordless_sign_in(user)

      delete settings_delete_api_token_path(token)

      expect(response).to redirect_to(settings_api_path)
      expect(flash[:notice]).to eq("API token revoked")
      expect(token.reload.revoked_at).to be_present
    end

    it "returns not found when the token belongs to another user" do
      user = create(:user)
      other_user_token = create(:api_token)
      passwordless_sign_in(user)

      delete settings_delete_api_token_path(other_user_token)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /settings/profile" do
    it "renders the profile tab and shell" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_profile_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('id="settings-tab-profile"')
      expect(response.body).to include('id="settings-tab-api"')
      expect(response.body).to include('aria-selected="true"')
      expect(response.body).to include('aria-controls="settings-panel-profile"')
      expect(response.body).to include('id="settings-panel-profile"')
      expect(response.body).to include("Email address")
      expect(response.body).not_to include("Create token")
    end
  end

  describe "GET /settings/api" do
    it "renders token management and only shows active tokens" do
      user = create(:user)
      active_token = create(:api_token, user:, name: "Active Token", last_used_at: nil)
      create(:api_token, user:, name: "Revoked Token", revoked_at: 1.minute.ago)
      create(:api_token, user:, name: "Expired Token", expires_at: 1.minute.ago)
      passwordless_sign_in(user)

      get settings_api_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('id="settings-tab-profile"')
      expect(response.body).to include('id="settings-tab-api"')
      expect(response.body).to include('aria-selected="true"')
      expect(response.body).to include('aria-controls="settings-panel-api"')
      expect(response.body).to include('id="settings-panel-api"')
      expect(response.body).to include("API tokens")
      expect(response.body).to include("Create token")
      expect(response.body).to include(active_token.name)
      expect(response.body).to include("Last used: Never")
      expect(response.body).not_to include("Revoked Token")
      expect(response.body).not_to include("Expired Token")
    end

    it "shows an empty state when there are no active tokens" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_api_path

      expect(response.body).to include("No active API tokens yet")
    end

    it "marks the api tab as selected" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_api_path

      expect(response.body).to include('id="settings-tab-api"')
      expect(response.body).to include('aria-controls="settings-panel-api"')
      expect(response.body).to include('aria-selected="true"')
      expect(response.body).not_to include("tab=")
    end
  end
end
