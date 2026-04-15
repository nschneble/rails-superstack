require "rails_helper"

RSpec.describe Demo::NewMacGuffinLikeNotifier, type: :model do
  describe "notification_methods #message" do
    it "returns a localized message with actor email and mac_guffin name" do
      actor = build(:user, email: "actor@example.com")
      mac_guffin = build(:mac_guffin, name: "The Briefcase")

      notification = described_class::Notification.new
      allow(notification).to receive_messages(params: { actor: }, record: mac_guffin)

      expect(notification.message).to include("actor@example.com", "The Briefcase")
    end
  end
end
