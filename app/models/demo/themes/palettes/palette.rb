module Demo::Themes::Palettes
  # Immutable value object defining a color palette for a demo theme
  Palette = Data.define(:background, :border, :text, :button, :button_text, :highlight)
end
