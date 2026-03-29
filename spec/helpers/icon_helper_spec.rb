require "rails_helper"

RSpec.describe IconHelper, type: :helper do
  describe "#fa_icon" do
    it "renders an i tag with solid style by default" do
      result = helper.fa_icon("circle")
      expect(result).to include("fa-solid")
      expect(result).to include("fa-circle")
    end

    it "includes additional CSS classes when provided" do
      result = helper.fa_icon("circle", "text-red-500")
      expect(result).to include("text-red-500")
    end

    it "uses the given style" do
      result = helper.fa_icon("circle", "", style: "regular")
      expect(result).to include("fa-regular")
    end
  end

  describe "#fas_icon" do
    it "renders with solid style" do
      result = helper.fas_icon("star")
      expect(result).to include("fa-solid")
      expect(result).to include("fa-star")
    end
  end

  describe "#far_icon" do
    it "renders with regular style" do
      result = helper.far_icon("star")
      expect(result).to include("fa-regular")
    end
  end

  describe "#fab_icon" do
    it "renders with brands style" do
      result = helper.fab_icon("github")
      expect(result).to include("fa-brands")
    end
  end

  describe "#fa_stacked_icon" do
    it "renders a span with both icons stacked" do
      result = helper.fa_stacked_icon(%w[square satellite-dish])
      expect(result).to include("fa-stack")
      expect(result).to include("fa-square")
      expect(result).to include("fa-satellite-dish")
    end

    it "applies per-icon and stack class options from an array" do
      result = helper.fa_stacked_icon(
        %w[square satellite-dish],
        [ "text-lime-500", "text-white", "my-stack-class" ]
      )
      expect(result).to include("my-stack-class")
      expect(result).to include("text-lime-500")
      expect(result).to include("text-white")
    end

    it "handles nil icon names without raising" do
      expect { helper.fa_stacked_icon([ nil, nil ]) }.not_to raise_error
    end
  end

  describe "#font_awesome_available?" do
    it "returns true when the kit URL is configured" do
      allow(Figaro.env).to receive(:font_awesome_kit_url)
        .and_return("https://kit.fontawesome.com/abc123.js")
      expect(helper.font_awesome_available?).to be(true)
    end

    it "returns false when the kit URL is blank" do
      allow(Figaro.env).to receive(:font_awesome_kit_url).and_return(nil)
      expect(helper.font_awesome_available?).to be(false)
    end
  end
end
