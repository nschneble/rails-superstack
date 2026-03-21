require "rails_helper"

RSpec.describe GlobalNotifications::BroadcastService, type: :service do
  subject(:result) { described_class.call(message:, actor: user) }

  let(:user) { create(:user, :admin) }
  let(:message) { "Deployment in 5 minutes." }

  describe "success" do
    it "returns a successful result" do
      expect(result).to be_success
    end
  end

  describe "failure: blank message" do
    let(:message) { "   " }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns :blank error" do
      expect(result.error).to eq(:blank)
    end
  end

  describe "failure: message exceeds 140 characters" do
    let(:message) { "a" * 141 }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns :too_long error" do
      expect(result.error).to eq(:too_long)
    end
  end

  describe "boundary: message exactly 140 characters" do
    let(:message) { "a" * 140 }

    it "returns success" do
      expect(result).to be_success
    end
  end
end
