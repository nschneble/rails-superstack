require "rails_helper"

RSpec.describe Pom::CopyToClipboardComponent, type: :component do
  describe "rendering" do
    it "renders emoji fallback when font_awesome is unavailable" do
      allow(Figaro.env).to receive(:font_awesome_kit_url).and_return(nil)
      render_inline(described_class.new)
      expect(rendered_content).to include("📋")
    end

    it "renders content when provided" do
      render_inline(described_class.new) { "Copy snippet" }
      expect(rendered_content).to include("Copy snippet")
    end
  end
end
