require "rails_helper"

RSpec.describe URLParser do
  describe ".call" do
    it "delegates to a new instance" do
      result = described_class.call("https://example.com")
      expect(result).to be_a(URI::HTTPS)
    end
  end

  describe "#call" do
    subject(:parser) { described_class.new }

    it "returns nil for nil" do
      expect(parser.call(nil)).to be_nil
    end

    it "returns nil for blank string" do
      expect(parser.call("")).to be_nil
      expect(parser.call("   ")).to be_nil
    end

    it "returns a URI for a valid https URL" do
      result = parser.call("https://example.com/path")
      expect(result).to be_a(URI::HTTPS)
      expect(result.host).to eq("example.com")
    end

    it "returns nil for an http URL" do
      expect(parser.call("http://example.com")).to be_nil
    end

    it "returns nil for a URI with an invalid structure" do
      expect(parser.call("not a uri [weird]")).to be_nil
    end

    describe "with a host constraint" do
      it "returns a URI when the host matches" do
        result = parser.call("https://api.example.com", host: /\Aapi\.example\.com\z/)
        expect(result).not_to be_nil
      end

      it "returns nil when the host does not match" do
        result = parser.call("https://evil.com", host: /\Aapi\.example\.com\z/)
        expect(result).to be_nil
      end
    end

    describe "with a custom scheme" do
      it "returns a URI when the scheme matches" do
        result = parser.call("ftp://files.example.com", scheme: "ftp")
        expect(result).not_to be_nil
      end
    end
  end
end
