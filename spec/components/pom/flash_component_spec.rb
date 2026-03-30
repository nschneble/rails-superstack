require "rails_helper"

RSpec.describe Pom::FlashComponent, type: :component do
  describe "rendering" do
    it "renders a fallback icon for an unrecognized variant" do
      component = described_class.new
      allow(component).to receive(:variant).and_return(:custom)
      render_inline(component) { "Flash message" }
      expect(rendered_content).to include("fa-question")
    end
  end
end
