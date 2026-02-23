require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "email_change_confirmation" do
    let(:user)    { create(:user) }
    let(:request) { create(:email_change_request) }
    let(:mail)    { UserMailer.with(request: request).email_change_confirmation }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm Your New Email Address")
      expect(mail.to).to eq([ request.new_email ])
      expect(mail.from).to eq([ "no-reply@rails-superstack.dev" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("Click here to confirm your new email address:")
      expect(mail.body.encoded).to include(email_change_url(token: request.token))
      expect(mail.body.encoded).to include("This link is valid for the next 10 minutes.")
    end
  end

  describe "mac_guffin_liked" do
    let(:owner) { create(:user) }
    let(:actor) { create(:user) }
    let(:mac_guffin) { create(:mac_guffin, user: owner, name: "Golden Idol") }
    let(:notification) { Demo::MacGuffinLikeNotifier.with(record: mac_guffin, actor: actor).deliver(owner).notifications.last }
    let(:mail) { UserMailer.with(notification: notification, record: mac_guffin, actor: actor, recipient: owner).mac_guffin_liked }

    it "renders the headers" do
      expect(mail.subject).to eq("#{actor.email} liked your MacGuffin")
      expect(mail.to).to eq([ owner.email ])
      expect(mail.from).to eq([ "no-reply@rails-superstack.dev" ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to include("#{actor.email} liked your MacGuffin \"Golden Idol\".")
      expect(mail.body.encoded).to include(demo_mac_guffins_url)
    end
  end
end
