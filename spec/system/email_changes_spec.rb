require "rails_helper"

RSpec.describe "Email changes", type: :system do
  let(:user) { create(:user, email: "current@example.com") }

  before { sign_in_as(user) }

  describe "visiting the profile settings tab" do
    it "shows the current email address in the field" do
      visit settings_profile_path

      expect(page).to have_field("Email address", with: "current@example.com")
    end

    it "shows the submit button as disabled before any changes" do
      visit settings_profile_path

      expect(page).to have_button("Update email", disabled: true)
    end

    it "enables the submit button after changing the email value" do
      visit settings_profile_path
      fill_in "Email address", with: "new@example.com"

      expect(page).to have_button("Update email", disabled: false)
    end

    it "disables the submit button when the value matches the current email" do
      visit settings_profile_path
      fill_in "Email address", with: "new@example.com"
      fill_in "Email address", with: "current@example.com"

      expect(page).to have_button("Update email", disabled: true)
    end
  end

  describe "when a pending email change request exists" do
    before { create(:email_change_request, user:, new_email: "pending@example.com") }

    it "shows the pending email in the disabled field" do
      visit settings_profile_path

      expect(page).to have_field("Email address", with: "pending@example.com", disabled: true)
    end

    it "shows the pending email in the flash notice" do
      visit settings_profile_path

      expect(page).to have_text("We've sent a confirmation link to pending@example.com")
    end
  end

  describe "submitting a valid email change request" do
    it "redirects to profile settings with a flash notice" do
      allow(Email::RequestService).to receive(:call)
        .and_return(ServiceResult.ok(double(new_email: "new@example.com")))

      visit settings_profile_path
      fill_in "Email address", with: "new@example.com"
      click_on "Update email"

      expect(page).to have_current_path(settings_profile_path)
      expect(page).to have_text("new@example.com")
    end
  end

  describe "submitting an already-taken email address" do
    it "shows an alert flash on the profile page" do
      allow(Email::RequestService).to receive(:call)
        .and_return(ServiceResult.fail(:unavailable))

      visit settings_profile_path
      fill_in "Email address", with: "taken@example.com"
      click_on "Update email"

      expect(page).to have_current_path(settings_profile_path)
      expect(page).to have_text("That email address is already in use")
    end
  end
end
