require "rails_helper"

RSpec.describe "API tokens", type: :system do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe "visiting the API settings tab" do
    it "shows the create form and empty state when no tokens exist" do
      visit settings_api_path

      expect(page).to have_field("Token name")
      expect(page).to have_button("Create token")
      expect(page).to have_text("No tokens")
    end

    it "lists existing active tokens" do
      create(:api_token, user:, name: "Production Key")

      visit settings_api_path

      expect(page).to have_text("Production Key")
    end

    it "does not list revoked tokens" do
      create(:api_token, user:, name: "Old Key", revoked_at: 1.minute.ago)

      visit settings_api_path

      expect(page).not_to have_text("Old Key")
    end
  end

  describe "creating a new API token" do
    it "shows the plaintext token in the reveal panel after creation" do
      visit settings_api_path
      fill_in "Token name", with: "CI Token"
      click_on "Create token"

      expect(page).to have_css("#api_token_reveal", visible: :visible)
      expect(find("code#token").text).to match(/\A[0-9a-f]{64}\z/)
    end

    it "adds the new token to the list via Turbo Stream" do
      visit settings_api_path
      fill_in "Token name", with: "Turbo Stream Token"
      click_on "Create token"

      within("#api_tokens_collection") do
        expect(page).to have_text("Turbo Stream Token")
      end
    end

    it "hides the empty state after the first token is created" do
      visit settings_api_path
      fill_in "Token name", with: "First Token"
      click_on "Create token"

      expect(page).not_to have_text("No tokens")
    end

    it "does not show the plaintext token on a subsequent visit" do
      visit settings_api_path
      fill_in "Token name", with: "One-Time Token"
      click_on "Create token"

      visit settings_api_path

      expect(page).to have_css("#api_token_reveal", visible: :hidden)
    end

    it "shows an inline error when the token name is blank" do
      visit settings_api_path
      fill_in "Token name", with: "   "
      click_on "Create token"

      within("#api_token_form") do
        expect(page).to have_text("can't be blank")
      end
    end
  end

  describe "revoking an API token" do
    let!(:api_token) { create(:api_token, user:, name: "Delete Me") }

    it "removes the token row from the list after accepting the confirm dialog" do
      visit settings_api_path

      accept_confirm("Delete Delete Me? There's no undo.") do
        within("##{dom_id(api_token)}") do
          find("button[type='submit']").click
        end
      end

      expect(page).not_to have_text("Delete Me")
    end

    it "shows the empty state after revoking the last token" do
      visit settings_api_path

      accept_confirm do
        within("##{dom_id(api_token)}") do
          find("button[type='submit']").click
        end
      end

      expect(page).to have_css("#api_tokens_empty", visible: :visible)
    end

    it "keeps the token in the list when the confirm dialog is dismissed" do
      visit settings_api_path

      dismiss_confirm do
        within("##{dom_id(api_token)}") do
          find("button[type='submit']").click
        end
      end

      expect(page).to have_text("Delete Me")
    end
  end
end
