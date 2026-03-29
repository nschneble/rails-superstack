require "rails_helper"

RSpec.describe WebhookEvent, type: :model do
  describe "validations" do
    subject { build(:webhook_event) }

    it { is_expected.to validate_presence_of(:stripe_event_id) }
    it { is_expected.to validate_presence_of(:event_type) }
    it { is_expected.to validate_presence_of(:payload) }
    it { is_expected.to validate_uniqueness_of(:stripe_event_id) }
  end

  it "enforces uniqueness of stripe_event_id at database level" do
    create(:webhook_event, stripe_event_id: "evt_db_unique_test")
    duplicate = build(:webhook_event, stripe_event_id: "evt_db_unique_test")

    expect { duplicate.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  describe "status enum" do
    it "defaults to pending" do
      event = create(:webhook_event)
      expect(event.status).to eq("pending")
    end

    it "transitions through statuses" do
      event = create(:webhook_event)
      event.update!(status: :processed)
      expect(event.reload.status).to eq("processed")
    end
  end
end
