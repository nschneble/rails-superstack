require "rails_helper"

RSpec.describe "Notifications", type: :system do
  describe "as an unauthenticated user" do
    it "redirects to sign-in" do
      visit notifications_path

      expect(page).to have_current_path(auth_sign_in_path)
    end
  end

  describe "as a non-admin user" do
    it "redirects to root with an access denied alert" do
      sign_in_as(create(:user))

      visit notifications_path

      expect(page).to have_current_path(root_path)
      expect(page).to have_text("You are not authorized to access this resource")
    end
  end

  describe "as an admin user" do
    let(:admin) { create(:user, :admin) }

    before { sign_in_as(admin) }

    it "renders the broadcast form" do
      visit notifications_path

      expect(page).to have_text("Broadcast to all users")
      expect(page).to have_field("Message (max 140 characters)")
      expect(page).to have_button("Send notification")
    end

    it "shows a success notice after sending a valid message" do
      allow(Notifications::BroadcastService).to receive(:call)
        .and_return(ServiceResult.ok(nil))

      visit notifications_path
      fill_in "Message (max 140 characters)", with: "Scheduled maintenance at midnight"
      click_on "Send notification"

      expect(page).to have_current_path(notifications_path)
      expect(page).to have_text("Notification sent")
    end

    it "shows an inline error when the message is blank" do
      visit notifications_path
      fill_in "Message (max 140 characters)", with: "   "
      click_on "Send notification"

      expect(page).to have_current_path(notifications_path)
      expect(page).to have_text("Broadcast to all users")
    end
  end
end
