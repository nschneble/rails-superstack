source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.6.3"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 8.0.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache and Action Cable
gem "solid_cache"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Catch unsafe migrations in development [https://github.com/ankane/strong_migrations]
gem "strong_migrations"

# Authentication without the icky-ness of passwords [https://github.com/mikker/passwordless]
gem "passwordless"

# The authorization Gem for Ruby on Rails [https://github.com/CanCanCommunity/cancancan]
gem "cancancan"

# A view helper for adding Gravatars to your Ruby on Rails app [https://github.com/nschneble/gravatar_image_tag]
gem "gravatar_image_tag", github: "nschneble/gravatar_image_tag", ref: "71b32fcffe461252aa4bb4fb9586ca0797af09ff"

# A full-featured admin dashboard inspired by Administrate and ActiveAdmin [https://github.com/ThibautBaissac/super_admin]
gem "super_admin", github: "nschneble/super_admin", ref: "f77c28bd6e1371d6b84aadbe31c2f2ce9bde67e2"

# Ruby wrapper for the CommonMark parser [https://github.com/gjtorikian/commonmarker]
gem "commonmarker"

# Beautiful, performant feature flags for Ruby [https://github.com/flippercloud/flipper]
gem "flipper"
gem "flipper-active_record"
gem "flipper-ui"

# Redis-backed Ruby library for creating background jobs [https://github.com/resque/resque]
gem "resque"
gem "resque-scheduler"

# Base component for building ViewComponents [https://github.com/pom-io/pom-component]
gem "pom-component"

# Cutting-edge, in-memory search engine for mere mortals [https://github.com/typesense/typesense-rails]
gem "typesense-rails", github: "typesense/typesense-rails", tag: "v1.0.0.rc7"

# The best pagination Ruby gem [https://github.com/ddnexus/pagy]
gem "pagy", "~> 43"

# A fresh, new GraphQL server designed for Rails [https://github.com/virtualshield/rails-graphql]
gem "rails-graphql", github: "nschneble/rails-graphql", ref: "164b858226d1348e7a2d4cfaa7a12e601ada2c58"

# Notifications for Ruby on Rails applications [https://github.com/excid3/noticed]
gem "noticed"

# Simple Rails app configuration [https://github.com/laserlemon/figaro]
gem "figaro"

# Stripe payments [https://github.com/stripe/stripe-ruby]
gem "stripe"

# Decorators for Rails apps [https://github.com/drapergem/draper]
gem "draper"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-factory_bot", require: false

  # RSpec testing framework [https://rspec.info/]
  gem "rspec-rails", "~> 8.0.4"

  # A library for setting up Ruby objects as test data [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails"

  # A library for generating fake data [https://github.com/faker-ruby/faker]
  gem "faker"

  # Simple SimpleCov coverage badges [https://github.com/traels-it/simplecov_badger]
  gem "simplecov_badger"

  # A Ruby code quality reporter [https://github.com/whitesmith/rubycritic]
  gem "rubycritic", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Terminal-based log viewer w/ real-time monitoring [https://github.com/silva96/log_bench]
  gem "log_bench"

  # Preview mail in the browser instead of sending [https://github.com/ryanb/letter_opener]
  gem "letter_opener"
  gem "letter_opener_web", github: "fgrehm/letter_opener_web", ref: "ff3b185099bb9a1cbd721929698bed71e533f194"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  # Simple one-liner tests for common Rails functionality [https://github.com/thoughtbot/shoulda-matchers]
  gem "shoulda-matchers", "~> 7.0"

  # Redis-backed Ruby library for creating background jobs [https://github.com/resque/resque]
  gem "resque_spec"

  # Code coverage for Ruby [https://github.com/simplecov-ruby/simplecov]
  gem "simplecov", require: false
  gem "simplecov-tailwindcss", require: false, github: "chiefpansancolt/simplecov-tailwindcss", ref: "0922239883d97a22c015e345dd0d1af1d41520e9"
end
