require "rails_helper"

RSpec.describe Demo::MacGuffinMailer, type: :mailer do
  include_context "with demo routes"

  describe "#mac_guffin_liked" do
    let(:recipient)  { create(:user) }
    let(:actor)      { create(:user) }
    let(:mac_guffin) { create(:mac_guffin, user: recipient) }
    let(:mail) do
      described_class.with(recipient:, actor:, record: mac_guffin).mac_guffin_liked
    end

    it "renders the headers" do
      expect(mail.to).to eq([ recipient.email ])
      expect(mail.from).to eq([ "no-reply@rails-superstack.dev" ])
      expect(mail.subject).to be_present
    end

    it "renders the body with the mac_guffin name" do
      expect(mail.body.encoded).to include(mac_guffin.name)
    end
  end
end
