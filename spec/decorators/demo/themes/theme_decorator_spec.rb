require "rails_helper"

RSpec.describe Demo::Themes::ThemeDecorator, type: :decorator do
  subject(:decorator) { described_class.new(theme) }

  let(:theme) { Demo::Themes::Theme.all.find { |t| t.image_attribution.present? } }


  describe "#price_display" do
    it "formats price_cents as a dollar amount" do
      expect(decorator.price_display).to match(/\A\$\d+\.\d{2}\z/)
    end
  end

  describe "#rendered_image_attribution" do
    it "renders plain string segments" do
      expect(decorator.rendered_image_attribution).to include("Photo by")
    end

    it "renders link segments as anchor tags" do
      expect(decorator.rendered_image_attribution).to include("<a")
    end

    it "renders nil for hash segments without a :link key" do
      theme = instance_double(Demo::Themes::Theme, price_cents: 1000, image_attribution: [ "Photo by", { alt: "someone" } ])
      result = described_class.new(theme).rendered_image_attribution
      expect(result).to include("Photo by")
    end

    it "renders nil for non-string, non-hash segments" do
      theme = instance_double(Demo::Themes::Theme, price_cents: 1000, image_attribution: [ "Photo by", 42 ])
      result = described_class.new(theme).rendered_image_attribution
      expect(result).to include("Photo by")
    end
  end
end
