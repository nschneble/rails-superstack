# Provides rainbow color text formatting!

module TextHelper
  RAINBOW_COLORS = [
    %w[red],
    %w[red blue],
    %w[red green blue],
    %w[red yellow green blue],
    %w[red yellow green blue violet],
    %w[red orange yellow green blue violet],
    %w[red orange yellow green blue indigo violet]
  ]

  COLOR_CLASSES = {
    "red"    => { "500" => "text-red-500" },
    "orange" => { "500" => "text-orange-500" },
    "yellow" => { "500" => "text-yellow-500" },
    "green"  => { "500" => "text-green-500" },
    "blue"   => { "500" => "text-blue-500" },
    "indigo" => { "500" => "text-indigo-500" },
    "violet" => { "500" => "text-violet-500" }
  }

  def color(text, color, shade = "500")
    tag.span text, class: COLOR_CLASSES.dig(color.to_s, shade) || "text-inherit"
  end

  def rainbow(text, shade = "500")
    return tag.span unless text.present?

    palette = palette_for_text(text)
    colored_chars = text.each_char.with_index.map do |char, index|
      color(char, palette[index % num_colors], shade)
    end
    tag.span safe_join(colored_chars)
  end

  private

  def palette_for_text(text)
    RAINBOW_COLORS[[ text.length, num_colors ].min - 1]
  end

  def num_colors
    COLOR_CLASSES.keys.count
  end
end
