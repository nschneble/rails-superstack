# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Lint", "bin/rubocop"
  step "Test", "bin/rspec"

  step "Gem audit", "bin/bundler-audit"
  step "Importmap vulnerability audit", "bin/importmap audit"
  step "Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"

  step "Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"
end
