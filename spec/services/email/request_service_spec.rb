require "rails_helper"

RSpec.describe Email::RequestService, type: :service do
  subject(:result) { described_class.call(user:, new_email:) }

  let(:user) { create(:user) }
  let(:new_email) { "new@example.com" }

  describe "success" do
    it "returns a successful result" do
      expect(result).to be_success
    end

    it "returns the created EmailChangeRequest as payload" do
      expect(result.payload).to be_a(EmailChangeRequest)
      expect(result.payload.new_email).to eq("new@example.com")
    end

    it "persists the EmailChangeRequest" do
      expect { result }.to change(EmailChangeRequest, :count).by(1)
    end

    it "enqueues an email change confirmation mail" do
      expect { result }.to have_enqueued_mail(UserMailer, :email_change_confirmation)
    end

    it "deletes expired requests for the same new email before creating" do
      expired = create(:email_change_request, new_email: "new@example.com").tap { |r| r.update_column(:expires_at, 1.minute.ago) }
      result
      expect(EmailChangeRequest.exists?(expired.id)).to be false
    end
  end

  describe "failure: invalid email" do
    let(:new_email) { "not-an-email" }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns :invalid error" do
      expect(result.error).to eq(:invalid)
    end

    it "does not enqueue any mail" do
      expect { result }.not_to have_enqueued_mail
    end

    it "does not create any EmailChangeRequest" do
      expect { result }.not_to change(EmailChangeRequest, :count)
    end
  end

  describe "failure: email taken by existing user" do
    before { create(:user, email: "new@example.com") }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns :unavailable error" do
      expect(result.error).to eq(:unavailable)
    end
  end

  describe "failure: active email change request already exists for that email" do
    before { create(:email_change_request, new_email: "new@example.com", expires_at: 10.minutes.from_now) }

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns :unavailable error" do
      expect(result.error).to eq(:unavailable)
    end
  end
end
