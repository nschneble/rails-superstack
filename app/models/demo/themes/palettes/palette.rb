module Demo::Themes::Palettes
  Palette = Data.define(:background, :border, :text, :button, :button_text, :highlight) do
    def initialize(
      background:  DefaultPalette.background,
      border:      DefaultPalette.border,
      text:        DefaultPalette.text,
      button:      DefaultPalette.button,
      button_text: DefaultPalette.button_text,
      highlight:   DefaultPalette.highlight
    )
      super
    end
  end
end
