# Custom SimpleCov formatter that outputs below RSpec test runs

class SimpleCov::Formatter::CustomFormatter
  def format(result)
    @stats = result
    $stdout.puts build_output.join("\n")
  end

  private

  def build_output
    [ "", *coverage_header, file_coverage, branch_coverage, line_coverage, "\n" ].compact
  end

  def coverage_header = [
    "╭────────────────────────────╮",
    "│ SimpleCov coverage summary │",
    "╰─┬──────────────────────────╯"
  ]

  def file_coverage
    "  ├─> #{@stats.files.count} files tracked with #{@stats.covered_percent.round(2)}% coverage"
  end

  def branch_coverage
    branch_stats = @stats.coverage_statistics[:branch]
    "  ├─> #{branch_stats.covered}/#{branch_stats.total} branches" if branch_stats.present?
  end

  def line_coverage
    "  └─> #{@stats.covered_lines}/#{@stats.total_lines} lines of code"
  end
end
