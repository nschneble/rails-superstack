require "rails_helper"

RSpec.describe Demo::MacGuffins::SearchService, type: :service do
  subject(:result) do
    described_class.call(
      ability: Ability.new(user),
      query: "*",
      page: 1,
      request: instance_double(ActionDispatch::Request, url: "http://example.com/demo/mac_guffins")
    )
  end

  let(:user) { create(:user) }

  describe "when there are no accessible mac_guffins" do
    it "returns success" do
      expect(result).to be_success
    end

    it "returns an empty results array" do
      _pagy, records = result.payload
      expect(records).to be_empty
    end

    it "returns a pagy object with zero count" do
      pagy, _records = result.payload
      expect(pagy.count).to eq(0)
    end
  end

  describe "when accessible mac_guffins exist and Typesense succeeds" do
    before do
      mac_guffin = create(:mac_guffin, user:, visibility: :open)
      fake_pagy = Pagy::Offset.new(count: 1, page: 1, limit: 4)
      allow(Demo::MacGuffin).to receive(:search).and_return([ fake_pagy, [ mac_guffin ] ])
    end

    it "returns success" do
      expect(result).to be_success
    end

    it "returns results in the payload" do
      _pagy, records = result.payload
      expect(records).not_to be_empty
    end
  end

  describe "when Typesense raises an error" do
    before do
      create(:mac_guffin, user:, visibility: :open)
      allow(Demo::MacGuffin).to receive(:search).and_raise(Typesense::Error.new("connection failed"))
    end

    it "returns a failure result" do
      expect(result).to be_failure
    end

    it "returns :search_unavailable error" do
      expect(result.error).to eq(:search_unavailable)
    end

    it "logs the error" do
      allow(Rails.logger).to receive(:error)
      result
      expect(Rails.logger).to have_received(:error)
    end

    it "returns an empty pagy and results in the payload" do
      _pagy, records = result.payload
      expect(records).to be_empty
    end
  end
end
