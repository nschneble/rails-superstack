require "rails_helper"

RSpec.describe ApiToken, type: :model do
  describe ".authenticate" do
    it "returns nil for a nil token" do
      expect(described_class.authenticate(nil)).to be_nil
    end

    it "returns nil for a blank token" do
      expect(described_class.authenticate("")).to be_nil
    end

    it "returns nil for an unknown token string" do
      expect(described_class.authenticate("unknown_token_xyz")).to be_nil
    end

    it "returns the token record for a valid active token" do
      token = create(:api_token)
      expect(described_class.authenticate(token.plaintext_token)).to eq(token)
    end

    it "returns nil for a revoked token" do
      token = create(:api_token, revoked_at: 1.minute.ago)
      expect(described_class.authenticate(token.plaintext_token)).to be_nil
    end

    it "returns nil for an expired token" do
      token = create(:api_token, expires_at: 1.minute.ago)
      expect(described_class.authenticate(token.plaintext_token)).to be_nil
    end
  end

  describe "#active?" do
    it "returns true when not revoked and no expiry is set" do
      token = build(:api_token, revoked_at: nil, expires_at: nil)
      expect(token.active?).to be(true)
    end

    it "returns true when not revoked and expiry is in the future" do
      token = build(:api_token, revoked_at: nil, expires_at: 1.hour.from_now)
      expect(token.active?).to be(true)
    end

    it "returns false when revoked" do
      token = build(:api_token, revoked_at: Time.current)
      expect(token.active?).to be(false)
    end

    it "returns false when expires_at is in the past" do
      token = build(:api_token, revoked_at: nil, expires_at: 1.second.ago)
      expect(token.active?).to be(false)
    end
  end

  describe "#mark_used!" do
    it "updates last_used_at to the current time" do
      token = create(:api_token)
      freeze_time do
        token.mark_used!
        expect(token.reload.last_used_at).to eq(Time.current)
      end
    end
  end
end
