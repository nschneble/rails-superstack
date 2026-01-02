module CodeHelper
  THEMES = {
    eighties:  { dark: "base16-eighties.dark", light: nil },
    github:    { dark: "InspiredGitHub",       light: nil },
    mocha:     { dark: "base16-mocha.dark",    light: nil },
    ocean:     { dark: "base16-ocean.dark",    light: "base16-ocean.light" },
    solarized: { dark: "Solarized (dark)",     light: "Solarized (light)" }
  }

  PRE_CLASSES = "mt-8 p-4 rounded-sm shadow-slate-600 shadow-xl"

  def flash_notice_sample_code
    snippet = <<~CODE
      class YourController < ApplicationController
        def index
          flash.notice = "Hello, world!"
          # ...
        end
      end
    CODE

    code = highlight_syntax(snippet)
    code.sub("<pre ", "<pre class=\"#{PRE_CLASSES}\"").html_safe
  end

  def flash_alert_sample_code
    snippet = <<~CODE
      class YourController < ApplicationController
        def index
          flash.alert = "Something bad happened"
          # ...
        end
      end
    CODE

    code = highlight_syntax(snippet)
    code.sub("<pre ", "<pre class=\"#{PRE_CLASSES}\"").html_safe
  end

  private

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
