require "rails_helper"

RSpec.describe CleanupExpiredEmailChangeRequestsJob do
  include ActiveSupport::Testing::TimeHelpers

  it "deletes expired email change requests" do
    travel_to 5.minutes.from_now do
      expired = create(:email_change_request, expires_at: 1.minute.ago)
      active = create(:email_change_request)

      described_class.perform

      expect(EmailChangeRequest.exists?(expired.id)).to be(false)
      expect(EmailChangeRequest.exists?(active.id)).to be(true)
    end
  end
end
