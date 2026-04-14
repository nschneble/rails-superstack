require "rails_helper"

RSpec.describe Notifications::FlashNotifiable do
  let(:dummy) do
    Class.new do
      include Notifications::FlashNotifiable

      def flash
        { "notice" => "Important message", "alert" => "" }
      end
    end.new
  end

  describe "#flash_notifications" do
    it "includes non-blank flash messages as Notification objects" do
      notifications = dummy.send(:flash_notifications)
      expect(notifications.map(&:message)).to include("Important message")
    end

    it "skips blank flash messages" do
      notifications = dummy.send(:flash_notifications)
      expect(notifications.count).to eq(1)
      expect(notifications.map(&:message)).not_to include("")
    end
  end
end
