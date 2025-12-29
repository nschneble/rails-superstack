# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Brakeman code analysis", "bin/brakeman --no-pager"
  step "Scan for known security vulnerabilities in bundled gems", "bin/bundler-audit"
  step "Scan for security vulnerabilities in JavaScript dependencies", "bin/importmap audit"

  step "Lint code for consistent style", "bin/rubocop"
  step "Run RSpec tests", "bin/rspec"

  # seeds are idempotent
  step "Check for bad seeds", "env RAILS_ENV=development bin/rails db:seed"

  if success?
    echo "CI passed. Ready for merge and deploy.", type: :success
  else
    failure "CI failed.", "Fix the issues above and try again."
  end
end
