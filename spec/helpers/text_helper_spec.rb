require "rails_helper"

RSpec.describe TextHelper, type: :helper do
  describe "#rainbow" do
    it "returns an empty span when text is blank" do
      expect(helper.rainbow("")).to eq("<span></span>")
    end

    it "returns an empty span when text is nil" do
      expect(helper.rainbow(nil)).to eq("<span></span>")
    end

    it "wraps each character in a colored span" do
      result = helper.rainbow("Hi")
      expect(result).to include("<span")
      expect(result).to include("H")
      expect(result).to include("i")
    end
  end

  describe "#color" do
    it "wraps text in a span with the correct color class" do
      result = helper.color("hello", "red")
      expect(result).to include("text-red-500")
      expect(result).to include("hello")
    end

    it "falls back to text-inherit for unknown colors" do
      result = helper.color("hello", "magenta")
      expect(result).to include("text-inherit")
    end
  end
end
