require "rails_helper"

RSpec.describe BaseParser do
  describe ".call" do
    it "delegates to a new instance via a subclass" do
      subclass = Class.new(described_class) { def call(*) = "parsed" }
      expect(subclass.call("anything")).to eq("parsed")
    end
  end

  describe "#call" do
    it "raises an error when called on BaseParser directly" do
      expect { described_class.new.call("value") }.to raise_error(Exception)
    end
  end
end
