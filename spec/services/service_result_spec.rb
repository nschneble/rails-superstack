require "rails_helper"

RSpec.describe ServiceResult do
  describe ".ok" do
    subject(:result) { described_class.ok }

    it { is_expected.to be_success }
    it { is_expected.not_to be_failure }

    it "has nil error" do
      expect(result.error).to be_nil
    end

    it "has nil payload by default" do
      expect(result.payload).to be_nil
    end

    context "with a payload" do
      subject(:result) { described_class.ok("data") }

      it "stores the payload" do
        expect(result.payload).to eq("data")
      end
    end
  end

  describe ".fail" do
    subject(:result) { described_class.fail(:something_went_wrong) }

    it { is_expected.not_to be_success }
    it { is_expected.to be_failure }

    it "stores the error" do
      expect(result.error).to eq(:something_went_wrong)
    end

    it "has nil payload" do
      expect(result.payload).to be_nil
    end
  end

  it "is immutable" do
    result = described_class.ok("data")
    expect { result.instance_variable_set(:@payload, "changed") }.to raise_error(FrozenError)
  end
end
