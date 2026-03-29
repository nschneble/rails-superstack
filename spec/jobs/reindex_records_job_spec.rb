require "rails_helper"

RSpec.describe ReindexRecordsJob do
  let(:record) { double("record", index!: nil, remove_from_index!: nil) } # rubocop:disable RSpec/VerifiedDoubles

  describe ".perform" do
    context "when remove is true" do
      it "calls remove_from_index! on the record" do
        described_class.perform(record, true)
        expect(record).to have_received(:remove_from_index!)
      end
    end

    context "when remove is false" do
      it "calls index! on the record" do
        described_class.perform(record, false)
        expect(record).to have_received(:index!)
      end
    end
  end
end
