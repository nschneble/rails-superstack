require "rails_helper"

RSpec.describe ReindexRecordsJob do
  let(:record) { double("record", index!: nil) } # rubocop:disable RSpec/VerifiedDoubles

  describe ".perform" do
    it "calls index! on the record" do
      described_class.perform(record)
      expect(record).to have_received(:index!)
    end
  end
end
