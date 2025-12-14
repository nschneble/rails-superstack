module IconHelper
  def fas_icon(name, options = "")
    fa_icon(name, options)
  end

  def far_icon(name, options = "")
    fa_icon(name, options, style: "regular")
  end

  def fab_icon(name, options = "")
    fa_icon(name, options, style: "brands")
  end

  def fa_icon(name, options = "", style: "solid")
    content_tag(:i, "", class: "fa-#{style} fa-#{name} #{options}".strip)
  end

  # Creates a stacked Font Awesome icon.
  #
  # fa_stacked_icon(
  #   ["square", "satellite-dish"],
  #   ["text-lime-500", "text-white"]
  # )
  #
  # @param names   Array of Font Awesome icon names: ["outer", "inner"]
  # @param options Array of Tailwind CSS attributes: ["outer", "inner", "stack"]
  # @param style   Font Awesome style name (e.g. "solid", "regular")
  #
  # @return A span tag with the stacked Font Awesome icon.
  def fa_stacked_icon(names, options, style: "solid")
    content_tag :span, class: "fa-stack #{options[2]}".strip do
      fa_icon(names[0]&.to_s, "fa-stack-2x #{options[0]}".strip, style:) +
      fa_icon(names[1]&.to_s, "fa-stack-1x #{options[1]}".strip, style:)
    end
  end
end
