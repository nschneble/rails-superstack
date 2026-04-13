# Project Configuration

## Tech Stack

- **Ruby** 3.4.7, **[Rails](https://rubyonrails.org)** 8.1.3, **[Postgres](https://www.postgresql.org)** 18
- **Front-end:** [Hotwire](https://hotwired.dev) (Turbo + Stimulus), [Tailwind](https://tailwindcss.com), [Pom Component](https://pom-io.github.io/pom-component), [Font Awesome](https://fontawesome.com), [Draper](https://github.com/drapergem/draper) (decorators)
- **Testing:** [RSpec](https://rspec.info), [Capybara](http://teamcapybara.github.io/capybara/), [Factory Bot](https://github.com/thoughtbot/factory_bot_rails), [Faker](https://github.com/faker-ruby/faker), [SimpleCov](https://github.com/simplecov-ruby/simplecov) (coverage)
- **Code Quality:** [RuboCop](https://rubocop.org), [RubyCritic](https://github.com/whitesmith/rubycritic)
- **Auth:** [Passwordless](https://github.com/mikker/passwordless) , [CanCanCan](https://github.com/CanCanCommunity/cancancan) (authorization)
- **Background Jobs:** [Resque](http://resque.github.io)
- **Search:** [Typesense](https://typesense.org), [Pagy](https://ddnexus.github.io/pagy) (pagination)
- **Notifications:** [Noticed](https://github.com/excid3/noticed)
- **APIs:** [GraphQL](https://rails-graphql.dev)
- **Billing:** [Stripe](https://github.com/stripe/stripe-ruby)
- **Admin:** [SuperAdmin](https://github.com/ThibautBaissac/super_admin), [Flipper](https://www.flippercloud.io) (feature flags)
- **Assets:** Propshaft + Import Maps (no Node.js)
- **App Config:** [Figaro](https://github.com/laserlemon/figaro)

## Architecture

```
app
├ components   # Pom Components (reusable UI with tests)
├ controllers  # Thin, delegates to services, renders responses
├ dashboards   # SuperAdmin dashboards
├ decorators   # Draper view formatting
├ graphql      # GraphQL API schemas + supporting files
├ helpers      # View helpers
├ jobs         # Resque background jobs, must be idempotent
├ mailers      # HTML + text templates for email delivery
├ models       # Persistence (validations, associations, scopes), simple predicates
├ normalizers  # Normalization utilities
├ notifiers    # Notified notification event objects + logic
├ parsers      # Parsing utilities
├ services     # Business logic that orchestrates models, APIs, side effects
├ validators   # Validation utilities
└ views        # ERB markup only, no logic!

lib
├ abilities    # CanCanCan authorization, default deny
├ data         # JSON data for immutable value objects (Data.define)
└ tasks        # Rake tasks
```

## Key Commands

```bash
# Setup
bin/setup                    # Set up project + start development server
bin/setup --skip-server      # Set up project + don't start development server
bin/setup --reset            # Reset project back to factory settings

# Run
bin/dev                      # Start development server
bin/dev --with-stripe        # start development server + listen for Stripe webhooks

# Linting
bin/rubocop                  # Lint code for consistent style
bin/rubocop -a               # Safe autocorrections only
bin/rubocop -A               # All autocorrections (safe and unsafe)
bin/rubocop -x               # Only fix formatting offenses

# Testing
bin/rspec                    # Run all RSpec tests
bin/rspec spec/my_spec.rb    # Run RSpec tests for a single file
bin/rspec spec/my_spec.rb:5  # Run RSpec tests for a single line

# Code Quality
bin/rubycritic               # Run code quality analysis

# Local CI
bin/ci                       # Run the GH CI workflow locally

# Security
bin/brakeman --no-pager      # Static code analysis
bin/bundler-audit            # Scan for vulnerabilities in bundled gems
bin/importmap audit          # Scan for vulnerabilities in JavaScript dependencies

# Database
bin/rails db:migrate         # Run migrations
bin/rails db:migrate:status  # Check migration status
bin/rails db:seed            # Seed database (should be idempotent)
bin/rails console            # Interactive Rails console
```

## Development Workflow

Use the [Test Driven Development](https://martinfowler.com/bliki/TestDrivenDevelopment.html) (TDD) technique.

Follow three simple steps repeatedly:

1. **RED:** Write a failing test describing the desired behavior
2. **GREEN:** Write minimal code to pass the test
3. **REFACTOR:** Improve code structure while keeping tests green

## Core Conventions

- **Skinny Everything:** Controllers orchestrate. Models persist. Services contain business logic. Views display
- **Callbacks:** Only for data normalization (e.g. `before_validation`, `before_save`). Side effects (such as emails, jobs, and APIs) belong in services
- **Services:** `.call` class method, return Result objects, namespace by domain (e.g. `Entities::CreateService`)
- **No premature abstraction:** Don't extract until complexity demands it. Three similar lines is better than implementing the wrong abstraction
- **Explicit > implicit:** Clear service calls over hidden callbacks. Named methods over metaprogramming

See [Rails Development Principles](../docs/rails-development-principles.md) for the complete development principles guide.

## Naming Conventions

| Layer      | Pattern                    | Example                         |
| ---------- | -------------------------- | ------------------------------- |
| Ability    | Namespaced + Plural Model  | `Abilities::Users`              |
| Component  | Namespaced + `Component`   | `Pom::ButtonComponent`          |
| Controller | Plural PascalCase          | `SessionsController`            |
| Decorator  | Model + `Decorator`        | `ApiTokenDecorator`             |
| Helper     | Descriptive + `Helper`     | `TailwindHelper`                |
| Job        | Descriptive + `Job`        | `ReindexRecordsJob`             |
| Mailer     | Model + `Mailer`           | `UserMailer`                    |
| Model      | Singular PascalCase        | `ApiToken`                      |
| Normalizer | Descriptive + `Normalizer` | `EmailNormalizer`               |
| Notifier   | Descriptive + `Notifier`   | `NewGlobalNotificationNotifier` |
| Parser     | Descriptive + `Parser`     | `EmailParser`                   |
| Service    | Namespaced + `Service`     | `Email::ConfirmService`         |
| Validator  | Descriptive + `Validator`  | `EmailValidator`                |
