module CodeHelper
  THEMES = {
    eighties:  { dark: "base16-eighties.dark", light: nil },
    github:    { dark: "InspiredGitHub",       light: nil },
    mocha:     { dark: "base16-mocha.dark",    light: nil },
    ocean:     { dark: "base16-ocean.dark",    light: "base16-ocean.light" },
    solarized: { dark: "Solarized (dark)",     light: "Solarized (light)" }
  }

  def highlight_syntax(snippet, syntax = "ruby", theme = :ocean, variant = :dark)
    return "<pre>Hello, world!</pre>" unless snippet.present?

    code = <<~CODE
      ```#{syntax.downcase}
      #{snippet}
      ```
    CODE

    theme = THEMES.dig(theme, variant) || THEMES.dig(:ocean, :dark)
    Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: theme } })
  end
end
