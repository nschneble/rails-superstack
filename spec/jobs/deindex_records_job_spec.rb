require "rails_helper"

RSpec.describe DeindexRecordsJob do
  let(:record) { double("record", remove_from_index!: nil) } # rubocop:disable RSpec/VerifiedDoubles

  describe ".perform" do
    it "calls remove_from_index! on the record" do
      described_class.perform(record)
      expect(record).to have_received(:remove_from_index!)
    end
  end
end
