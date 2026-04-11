# Provides syntax highlighting helpers

module CodeHelper
  THEMES = {
    eighties:  { dark: "base16-eighties.dark", light: nil },
    github:    { dark: "InspiredGitHub",       light: nil },
    mocha:     { dark: "base16-mocha.dark",    light: nil },
    ocean:     { dark: "base16-ocean.dark",    light: "base16-ocean.light" },
    solarized: { dark: "Solarized (dark)",     light: "Solarized (light)" }
  }

  def highlight_syntax(snippet, syntax = "ruby", **kwargs)
    return "<pre>Hello, world!</pre>" unless snippet.present?

    code = <<~CODE
      ```#{syntax.downcase}
      #{snippet}
      ```
    CODE

    theme_key  = kwargs.fetch(:theme, :ocean)
    variant_key = kwargs.fetch(:variant, :dark)
    theme = THEMES.dig(theme_key, variant_key) || THEMES.dig(:ocean, :dark)

    Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: } })
  end
end
