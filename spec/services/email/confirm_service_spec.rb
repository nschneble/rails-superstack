require "rails_helper"

RSpec.describe Email::ConfirmService, type: :service do
  subject(:result) { described_class.call(token: ecr.token) }

  let(:user) { create(:user, email: "old@example.com") }
  let(:ecr) { create(:email_change_request, user:, new_email: "new@example.com") }

  describe "success" do
    it "returns a successful result" do
      expect(result).to be_success
    end

    it "returns the updated user as payload" do
      expect(result.payload).to eq(user)
    end

    it "updates the user's email" do
      result
      expect(user.reload.email).to eq("new@example.com")
    end

    it "sets email_confirmed_at" do
      freeze_time do
        result
        expect(user.reload.email_confirmed_at).to eq(Time.current)
      end
    end

    it "deletes all email change requests for the user" do
      create(:email_change_request, user:)
      result
      expect(user.email_change_requests.count).to eq(0)
    end
  end

  describe "failure: expired request" do
    let(:ecr) { create(:email_change_request, :expired, user:, new_email: "new@example.com") }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns link_expired error" do
      expect(result.error).to eq("link_expired")
    end

    it "destroys the expired request" do
      token = ecr.token # force creation before the change block
      expect { described_class.call(token:) }.to change(EmailChangeRequest, :count).by(-1)
    end

    it "does not update the user's email" do
      result
      expect(user.reload.email).to eq("old@example.com")
    end
  end

  describe "failure: new email stolen by another user" do
    before { create(:user, email: "new@example.com") }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns unavailable error" do
      expect(result.error).to eq("unavailable")
    end

    it "destroys the request" do
      token = ecr.token # force creation before the change block
      expect { described_class.call(token:) }.to change(EmailChangeRequest, :count).by(-1)
    end
  end

  describe "missing token" do
    subject(:result) { described_class.call(token: "bogus-token") }

    it "raises ActiveRecord::RecordNotFound" do
      expect { result }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
