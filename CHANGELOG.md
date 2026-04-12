# 🪵 Changelog

**All notable project changes will be documented in this file.** The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Pride Versioning](https://pridever.org) → `PROUD.DEFAULT.SHAME`

## [Unreleased]

_Nothing here!_

## [1.0.0] - 2026-04-11

### Added

**TL;DR:** Literally ✨everything✨

#### Front-end

- [Ruby on Rails](https://rubyonrails.org) + [Hotwire](https://hotwired.dev) + [Tailwind](https://tailwindcss.com)
- [Pom Component](https://pom-io.github.io/pom-component) + [Draper](https://github.com/drapergem/draper) (view components + decorators)
- [Font Awesome](https://fontawesome.com) + [Gravatar Image Tag Plugin](https://github.com/mdeering/gravatar_image_tag) (icons)
- [Commonmarker](https://github.com/gjtorikian/commonmarker) (syntax highlighting)

#### Back-end

- [Puma](https://puma.io)
- [Passwordless](https://github.com/mikker/passwordless) + [CanCanCan](https://github.com/CanCanCommunity/cancancan) (auth + roles)
- [Resque](http://resque.github.io) (background jobs)
- [Typesense](https://typesense.org) + [Pagy](https://ddnexus.github.io/pagy) (search + pagination)
- [GraphQL](https://rails-graphql.dev) (API)
- [Noticed](https://github.com/excid3/noticed) (notifications)
- [Stripe](https://github.com/stripe/stripe-ruby) (payments + subscriptions)

#### Database

- [Postgres](https://www.postgresql.org)
- [Strong Migrations](https://github.com/ankane/strong_migrations) (catch unsafe migrations)

#### Developer Experience

- [RuboCop](https://rubocop.org)
- [LogBench](https://github.com/silva96/log_bench) (log viewer)
- [RSpec](https://rspec.info) + [Factory Bot](https://github.com/thoughtbot/factory_bot_rails) + [Faker](https://github.com/faker-ruby/faker) (testing)
- [SimpleCov](https://github.com/simplecov-ruby/simplecov) + [SimpleCov Tailwind](https://simplecov-tailwind.chiefpansancolt.dev/) + [SimpleCov Badger](https://coverage.traels.it/) (code coverage)
- [RubyCritic](https://github.com/whitesmith/rubycritic) (code quality)
- [Letter Opener](https://github.com/ryanb/letter_opener) + [Letter Opener Web](https://github.com/fgrehm/letter_opener_web) (preview emails)
- [SuperAdmin](https://github.com/ThibautBaissac/super_admin) + [Flipper](https://www.flippercloud.io) (admin + feature flags)
- [Figaro](https://github.com/laserlemon/figaro) (app configuration)
- [Rails AI Agents](https://github.com/ThibautBaissac/rails_ai_agents) (AI agents)

#### Scripts

- `bin/cleanup` → _Removes all demo code_
- `bin/rename` → _Wires up your repo name and origin_

[Unreleased]: https://github.com/nschneble/rails-superstack/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/nschneble/rails-superstack/releases/tag/v1.0.0
