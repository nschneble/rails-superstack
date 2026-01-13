require 'rails_helper'

RSpec.describe EmailChangeRequest, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it "is valid with factory defaults" do
      expect(build(:email_change_request)).to be_valid
    end

    it "requires a user" do
      request = build(:email_change_request, user: nil)
      expect(request).not_to be_valid
      expect(request.errors[:user]).to be_present
    end

    it "requires a new email address" do
      request = build(:email_change_request, new_email: nil)
      expect(request).not_to be_valid
      expect(request.errors[:new_email]).to be_present
    end

    it "requires a token" do
      request = create(:email_change_request)
      request.token = nil

      expect(request).not_to be_valid
      expect(request.errors[:token]).to be_present
    end

    it "enforces a unique token" do
      request = create(:email_change_request)
      duplicate = build(:email_change_request, token: request.token)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:token]).to be_present
    end

    it "requires an expiration date" do
      request = create(:email_change_request)
      request.expires_at = nil

      expect(request).not_to be_valid
      expect(request.errors[:expires_at]).to be_present
    end

    it "requires an expiration date in the future" do
      request = build(:email_change_request, expires_at: 10.minutes.ago)
      expect(request).not_to be_valid
      expect(request.errors[:expires_at]).to be_present
    end
  end

  describe "callbacks" do
    it "generates a token on create if missing" do
      request = create(:email_change_request, token: nil)
      expect(request.token).to be_present
    end

    it "sets expiration date on create if missing" do
      request = create(:email_change_request, expires_at: nil)
      expect(request.expires_at).to be_present
    end

    it "normalizes the new email address" do
      request = create(:email_change_request, new_email: " nEwEmAiL@eXaMpLe.CoM   ")
      expect(request.new_email).to eq("newemail@example.com")
    end
  end

  describe "#expired?" do
    it "returns false when the expiration date is in the future" do
      request = create(:email_change_request, expires_at: 10.minutes.from_now)
      expect(request.expired?).to be(false)
    end

    it "returns true when the expiration date is in the past" do
      request = create(:email_change_request)
      request.expires_at = 10.minutes.ago

      expect(request.expired?).to be(true)
    end
  end

  describe ".active" do
    it "only returns requests that haven't expired" do
      active_request = create(:email_change_request, expires_at: 10.minutes.from_now)
      expired_request = create(:email_change_request, expires_at: 1.minutes.from_now)

      travel_to 5.minutes.from_now do
        expect(described_class.active).to include(active_request)
        expect(described_class.active).not_to include(expired_request)
      end
    end
  end
end
