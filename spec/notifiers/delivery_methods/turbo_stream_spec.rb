require "rails_helper"

RSpec.describe DeliveryMethods::TurboStream do
  describe "#resolve_message" do
    it "uses config[:message] when the :message key is present in config" do
      delivery = described_class.new
      config = double("config") # rubocop:disable RSpec/VerifiedDoubles
      allow(config).to receive(:key?).with(:message).and_return(true)
      allow(delivery).to receive(:config).and_return(config)
      allow(delivery).to receive(:evaluate_option).with(:message).and_return("Explicit message")

      expect(delivery.send(:resolve_message)).to eq("Explicit message")
    end

    it "falls back to notification.message when :message is absent from config" do
      delivery = described_class.new
      config = double("config") # rubocop:disable RSpec/VerifiedDoubles
      notification = double("notification", message: "Notification message") # rubocop:disable RSpec/VerifiedDoubles
      allow(config).to receive(:key?).with(:message).and_return(false)
      allow(delivery).to receive_messages(config: config, notification: notification)

      expect(delivery.send(:resolve_message)).to eq("Notification message")
    end
  end

  describe "#deliver" do
    it "broadcasts to the turbo stream channel" do
      delivery = described_class.new
      allow(delivery).to receive(:evaluate_option).with(:stream).and_return("test_stream")
      allow(delivery).to receive(:evaluate_option).with(:variant).and_return(nil)
      allow(delivery).to receive(:resolve_message).and_return("Hello")
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_to)

      delivery.deliver

      expect(Turbo::StreamsChannel).to have_received(:broadcast_append_to).with(
        "test_stream",
        hash_including(target: "notifications", partial: "shared/notification")
      )
    end
  end
end
