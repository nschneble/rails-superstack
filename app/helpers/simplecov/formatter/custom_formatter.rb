# Custom SimpleCov formatter that outputs below RSpec test runs

class SimpleCov::Formatter::CustomFormatter
  def format(result)
    $stdout.puts build_output(result).join("\n")
  end

  private

  def build_output(result)
    [
      "",
      *coverage_header,
      "  ├─> #{result.files.count} files tracked with #{result.covered_percent.round(2)}% coverage",
      branch_coverage_line(result.coverage_statistics[:branch]),
      "  └─> #{result.covered_lines}/#{result.total_lines} lines of code",
      "",
      ""
    ].compact
  end

  def coverage_header
    [
      "╭────────────────────────────╮",
      "│ SimpleCov coverage summary │",
      "╰─┬──────────────────────────╯"
    ]
  end

  def branch_coverage_line(stats)
    "  ├─> #{stats.covered}/#{stats.total} branches" if stats.present?
  end
end
