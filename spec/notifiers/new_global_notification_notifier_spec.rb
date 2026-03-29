require "rails_helper"

RSpec.describe NewGlobalNotificationNotifier, type: :model do
  describe ".with" do
    it "stores the message in params" do
      event = described_class.with(message: "Test broadcast")
      expect(event.params[:message]).to eq("Test broadcast")
    end
  end

  describe "notification_methods #message" do
    it "returns the message from params" do
      notification = NewGlobalNotificationNotifier::Notification.new
      allow(notification).to receive(:params).and_return({ message: "Test broadcast" })
      expect(notification.message).to eq("Test broadcast")
    end
  end
end
