class SimpleCov::Formatter::CustomFormatter
  def format(result)
    output = []

    output << ""
    output << "╭────────────────────────────╮"
    output << "│ SimpleCov coverage summary │"
    output << "╰─┬──────────────────────────╯"
    output << "  ├─> #{result.files.count} files tracked with #{result.covered_percent.round(2)}% coverage"

    branch_coverage_stats = result.coverage_statistics[:branch]
    if branch_coverage_stats.present?
      output << "  ├─> #{branch_coverage_stats.covered}/#{branch_coverage_stats.total} branches"
    end

    output << "  └─> #{result.covered_lines}/#{result.total_lines} lines of code"
    output << ""
    output << ""

    $stdout.puts output.join("\n")
  end
end
