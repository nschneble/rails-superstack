require "rails_helper"

RSpec.describe "Sign in", type: :system do
  describe "visiting the sign-in form while unauthenticated" do
    it "renders the email input" do
      visit auth_sign_in_path

      expect(page).to have_field("Email Address")
    end
  end

  describe "submitting the sign-in form" do
    it "shows the verify page after submitting" do
      visit auth_sign_in_path
      fill_in "Email Address", with: "someone@example.com"
      click_on "Send Login Code"

      expect(page).to have_current_path(%r{/sign_in/\w+}, url: false)
    end
  end

  describe "magic link confirmation" do
    it "signs in the user and redirects to root" do
      user = create(:user)
      sign_in_as(user)

      expect(page).to have_current_path(root_path)
    end
  end

  describe "visiting sign-in form while already authenticated" do
    it "redirects to root with a flash notice" do
      user = create(:user)
      sign_in_as(user)

      visit auth_sign_in_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_text("You're already signed in")
    end
  end

  describe "signing out" do
    it "clears the session and redirects to root" do
      user = create(:user)
      sign_in_as(user)

      visit auth_sign_out_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_text("You've signed out successfully")
    end
  end
end
