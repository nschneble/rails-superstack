require "rails_helper"

RSpec.describe "Email changes", type: :request do
  describe "POST /email_change" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        post create_email_change_path, params: { new_email: "new@example.com" }
        expect(response).to redirect_to(auth_sign_in_path)
      end
    end

    context "when authenticated" do
      let(:user) { create(:user) }

      before { passwordless_sign_in(user) }

      it "redirects to settings profile with a notice on success" do
        fake_request = instance_double(EmailChangeRequest, new_email: "new@example.com")
        allow(Email::RequestService).to receive(:call).and_return(ServiceResult.ok(fake_request))

        post create_email_change_path, params: { new_email: "new@example.com" }

        expect(response).to redirect_to(settings_profile_path)
        expect(flash[:notice]).to be_present
      end

      it "redirects to settings profile with an alert on failure" do
        allow(Email::RequestService).to receive(:call).and_return(ServiceResult.fail(:invalid))

        post create_email_change_path, params: { new_email: "bad" }

        expect(response).to redirect_to(settings_profile_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH /email_change" do
    let(:user) { create(:user) }

    before { passwordless_sign_in(user) }

    it "redirects to root with a notice on success" do
      allow(Email::ConfirmService).to receive(:call).and_return(ServiceResult.ok(nil))

      get update_email_change_path, params: { token: "valid-token" }

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to be_present
    end

    it "redirects to root with an alert on failure" do
      allow(Email::ConfirmService).to receive(:call).and_return(ServiceResult.fail(:link_expired))

      get update_email_change_path, params: { token: "expired-token" }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to be_present
    end

    it "redirects to root with an alert for an invalid token" do
      allow(Email::ConfirmService).to receive(:call).and_return(ServiceResult.fail(:invalid_link))

      get update_email_change_path, params: { token: "bogus-token" }

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq(I18n.t("email.confirmation.invalid_link"))
    end
  end
end
