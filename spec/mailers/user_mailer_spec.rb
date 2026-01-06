require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "email_change_confirmation" do
    let(:user)    { create(:user) }
    let(:request) { create(:email_change_request) }
    let(:mail)    { UserMailer.with(request: request).email_change_confirmation }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm Your New Email Address")
      expect(mail.to).to eq([ request.new_email ])
      expect(mail.from).to eq([ "no-reply@superstack.dev" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Click here to confirm your new email address:")
      expect(mail.body.encoded).to include(confirm_email_change_url(token: request.token))
      expect(mail.body.encoded).to include("This link is valid for the next 10 minutes.")
    end
  end
end
