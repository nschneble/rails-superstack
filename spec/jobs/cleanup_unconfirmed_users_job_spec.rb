require "rails_helper"

RSpec.describe CleanupUnconfirmedUsersJob do
  include ActiveSupport::Testing::TimeHelpers

  let(:stale_after_days) { 7 }

  it "deletes users with unconfirmed emails older than the cutoff" do
    travel_to 1.day.from_now do
      old_unconfirmed = create(:user, created_at: 10.days.ago)
      old_confirmed = create(:user, :confirmed, email_confirmed_at: 9.days.ago, created_at: 10.days.ago)
      recent_unconfirmed = create(:user, created_at: 2.days.ago)

      described_class.perform(stale_after_days)

      expect(User.exists?(old_unconfirmed.id)).to be(false)
      expect(User.exists?(old_confirmed.id)).to be(true)
      expect(User.exists?(recent_unconfirmed.id)).to be(true)
    end
  end
end
