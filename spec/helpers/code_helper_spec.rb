require "rails_helper"

RSpec.describe CodeHelper, type: :helper do
  describe "#highlight_syntax" do
    it "returns a pre placeholder when snippet is nil" do
      expect(helper.highlight_syntax(nil)).to eq("<pre>Hello, world!</pre>")
    end

    it "returns a pre placeholder when snippet is empty" do
      expect(helper.highlight_syntax("")).to eq("<pre>Hello, world!</pre>")
    end

    it "returns a pre placeholder when snippet is whitespace only" do
      expect(helper.highlight_syntax("   ")).to eq("<pre>Hello, world!</pre>")
    end

    it "returns rendered HTML for a valid snippet" do
      result = helper.highlight_syntax("puts 'hello'")
      expect(result).to include("<pre")
      expect(result).to include("hello")
    end

    it "falls back to ocean dark when the theme key is unknown" do
      result = helper.highlight_syntax("puts 'hi'", "ruby", :unknown_theme, :dark)
      expect(result).to be_present
    end

    it "falls back to ocean dark when the variant is nil for the given theme" do
      # :github has no :light variant, so THEMES.dig(:github, :light) returns nil
      result = helper.highlight_syntax("puts 'hi'", "ruby", :github, :light)
      expect(result).to be_present
    end

    it "uses the solarized light theme when requested" do
      allow(Commonmarker).to receive(:to_html).and_call_original
      helper.highlight_syntax("puts 'hi'", "ruby", :solarized, :light)
      expect(Commonmarker).to have_received(:to_html).with(
        anything,
        plugins: { syntax_highlighter: { theme: "Solarized (light)" } }
      )
    end

    it "uses the syntax argument as the language fence" do
      allow(Commonmarker).to receive(:to_html).and_call_original
      helper.highlight_syntax("SELECT 1", "sql")
      expect(Commonmarker).to have_received(:to_html).with(
        include("```sql"),
        anything
      )
    end
  end
end
