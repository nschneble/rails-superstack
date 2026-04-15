require "rails_helper"

RSpec.describe Demo::Themes::Theme, type: :model do
  describe "#selector" do
    it "returns a dasherized version of the key" do
      theme = described_class.find("crimson_tide")
      expect(theme.selector).to eq("crimson-tide")
    end
  end

  describe ".default" do
    it "returns the theme with key 'default'" do
      theme = described_class.default
      expect(theme.key).to eq("default")
    end
  end

  describe ".purchasable" do
    it "excludes the default theme" do
      keys = described_class.purchasable.map(&:key)
      expect(keys).not_to include("default")
    end
  end
end
