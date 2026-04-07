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

    it "creates a token and redirects with a flash notice" do
      user = create(:user)
      passwordless_sign_in(user)

      expect do
        post settings_create_api_token_path, params: { api_token: { name: "Spec Token" } }
      end.to change(user.api_tokens, :count).by(1)

      expect(response).to redirect_to(settings_api_path)
      expect(flash[:notice]).to eq("API token created")
    end

    it "shows the plaintext token once and clears it on subsequent visit" do
      user = create(:user)
      passwordless_sign_in(user)

      post settings_create_api_token_path, params: { api_token: { name: "Spec Token" } }

      plaintext = session[:api_token_plaintext]
      expect(plaintext).to be_present

      follow_redirect!
      expect(response.body).to include("Spec Token")
      expect(response.body).to include(plaintext.to_s)

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

    it "creates a token and returns a turbo stream response" do
      user = create(:user)
      passwordless_sign_in(user)

      expect do
        post settings_create_api_token_path,
          params: { api_token: { name: "Turbo Token" } },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end.to change(user.api_tokens, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end

    it "streams the new token content into the list" do
      user = create(:user)
      passwordless_sign_in(user)

      post settings_create_api_token_path,
        params: { api_token: { name: "Turbo Token" } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

      token = user.api_tokens.order(:created_at).last

      expect(response.body).to include(%(action="prepend" target="api_tokens_collection"))
      expect(response.body).to include(%(id="#{ActionView::RecordIdentifier.dom_id(token)}"))
      expect(response.body).to include("Turbo Token")
      expect(response.body).to include(token.plaintext_token.to_s)
      expect(response.body).to include(%(action="replace" target="api_token_form"))
    end

    it "returns an unprocessable turbo stream when invalid" do
      user = create(:user)
      passwordless_sign_in(user)

      post settings_create_api_token_path,
        params: { api_token: { name: " " } },
        headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include(%(action="replace" target="api_token_form"))
      expect(response.body).to include("Name can&#39;t be blank")
    end
  end

  describe "DELETE /settings/api_token/:id" do
    it "requires authentication" do
      token = create(:api_token)

      delete settings_revoke_api_token_path(token)

      expect(response).to redirect_to(auth_sign_in_path)
      expect(flash[:alert]).to eq("You must be logged in to visit this page")
    end

    it "revokes an active token owned by the current user" do
      user = create(:user)
      token = create(:api_token, user:, revoked_at: nil)
      passwordless_sign_in(user)

      delete settings_revoke_api_token_path(token)

      expect(response).to redirect_to(settings_api_path)
      expect(flash[:notice]).to eq("API token revoked")
      expect(token.reload.revoked_at).to be_present
    end

    it "streams a removal for turbo requests" do
      user = create(:user)
      token = create(:api_token, user:, revoked_at: nil)
      passwordless_sign_in(user)

      delete settings_revoke_api_token_path(token), headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include(%(action="remove" target="#{ActionView::RecordIdentifier.dom_id(token)}"))
      expect(token.reload.revoked_at).to be_present
    end

    it "restores the empty state after removing the last token with turbo" do
      user = create(:user)
      token = create(:api_token, user:, revoked_at: nil)
      passwordless_sign_in(user)

      delete settings_revoke_api_token_path(token), headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response.body).to include(%(action="replace" target="api_tokens_empty"))
      expect(response.body).to include("No tokens")
    end

    it "returns not found when the token belongs to another user" do
      user = create(:user)
      other_user_token = create(:api_token)
      passwordless_sign_in(user)

      delete settings_revoke_api_token_path(other_user_token)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /settings/billing" do
    it "renders the billing tab" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_billing_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('id="settings-tab-billing"')
    end

    it "requires authentication" do
      get settings_billing_path
      expect(response).to redirect_to(auth_sign_in_path)
    end
  end

  describe "GET /settings/profile with a pending email change" do
    it "shows the pending email address in the flash notice" do
      user = create(:user)
      create(:email_change_request, user:, new_email: "pending@example.com")
      passwordless_sign_in(user)

      get settings_profile_path

      expect(response.body).to include("pending@example.com")
    end
  end

  describe "GET /settings/profile" do
    it "returns a successful response with the settings navigation" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_profile_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('id="settings-tab-profile"')
      expect(response.body).to include('id="settings-tab-api"')
      expect(response.body).to include('aria-selected="true"')
      expect(response.body).to include('aria-controls="settings-panel-profile"')
    end

    it "renders the profile panel content" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_profile_path

      expect(response.body).to include('id="settings-panel-profile"')
      expect(response.body).to include("Email address")
      expect(response.body).not_to include("Create token")
    end
  end

  describe "GET /settings/api" do
    context "with a mix of active and inactive tokens" do
      let(:user) { create(:user) }
      let!(:active_token) { create(:api_token, user:, name: "Active Token", last_used_at: nil) }

      before do
        create(:api_token, user:, name: "Revoked Token", revoked_at: 1.minute.ago)
        create(:api_token, user:, name: "Expired Token", expires_at: 1.minute.ago)
        passwordless_sign_in(user)
        get settings_api_path
      end

      it "renders the settings shell with the api tab selected" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('id="settings-tab-profile"')
        expect(response.body).to include('id="settings-tab-api"')
        expect(response.body).to include('aria-selected="true"')
        expect(response.body).to include('aria-controls="settings-panel-api"')
      end

      it "renders the api tokens panel with management controls" do
        expect(response.body).to include('id="settings-panel-api"')
        expect(response.body).to include("API tokens")
        expect(response.body).to include("Create token")
      end

      it "renders the active token with details and actions" do
        expect(response.body).to include(active_token.name)
        expect(response.body).to include(%(id="api_tokens_collection"))
        expect(response.body).to include(%(id="#{ActionView::RecordIdentifier.dom_id(active_token)}"))
        expect(response.body).to include(%(data-turbo-confirm="Delete Active Token? There&#39;s no undo."))
        expect(response.body).to include("Last used: Never")
      end

      it "hides revoked and expired tokens" do
        expect(response.body).not_to include("Revoked Token")
        expect(response.body).not_to include("Expired Token")
      end
    end

    it "renders the last_used_at time when a token has been used" do
      user = create(:user)
      create(:api_token, user:, name: "Used Token", last_used_at: 2.hours.ago)
      passwordless_sign_in(user)

      get settings_api_path

      expect(response.body).to include("Last used:")
      expect(response.body).to include("ago")
    end

    it "shows an empty state when there are no active tokens" do
      user = create(:user)
      passwordless_sign_in(user)

      get settings_api_path

      parsed_html = Nokogiri::HTML.parse(response.body)
      expect(parsed_html.text).to include("No tokens")
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
