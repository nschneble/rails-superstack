_Author's Note: This is a work-in-progress. I wouldn't recommend using it just yet._
---

<p align="center">
  <img src="public/icon.png" alt="Rails Superstack" />
  <br />
</p>

[![CI](https://github.com/nschneble/rails-superstack/actions/workflows/ci.yml/badge.svg)](https://github.com/nschneble/rails-superstack/actions/workflows/ci.yml) [![License: CC0-1.0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0)

Rails Superstack is a ready-to-go Ruby on Rails instance with front-end, database, and accouterments.

__In other words, it's is a majestic monolith with a f*ckton of useful gems.__

It's a free public template anyone can use to hit the ground running.

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Run the rename script](#run-the-rename-script)
  - [Set up Font Awesome](#set-up-font-awesome)
  - [Build and run](#build-and-run)
- [What's in a Superstack, Exactly?](#whats-in-a-superstack-exactly)
  - [Tech stack](#tech-stack)
  - [Gems and resources](#gems-and-resources)
- [Linting, Testing, and CI](#linting-testing-and-ci)
  - [Linting](#linting)
  - [Testing](#testing)
  - [Local CI](#local-ci)

## Getting Started
First things first. [Create a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template) from this template. It's only two steps!
1. Click on "Use this template" above the file list
1. Select "Create a new repository"

Clone your new repository to your local machine, and you're done! (Okay I suppose that's _technically_ three steps)

### Prerequisites
With your shiny new repo in hand, here's what you need to get cooking:
* PostgreSQL 14.20
* Ruby 3.4.7
* [Bundler](https://bundler.io/) 2.7.2

The house recommends [Homebrew](https://brew.sh) and [rbenv](https://rbenv.org) to install these prerequisites:

```bash
cd /path/to/your/repo

# Install Homebrew + Postgres
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install postgresql@14

# Install rbenv + Ruby
curl -fsSL https://rbenv.org/install.sh | bash
rbenv install 3.4.7

# Install Bundler
gem install bundler -v 2.7.2
```
### Run the rename script
Unless you want your app to be called "Rails Superstack", you'll probably want to continue by running this script:

```bash
cd /path/to/your/repo
bin/rename_to "Your App"
```

### Set up Font Awesome
This one's easy. Navigate to [Get Started with Font Awesome](https://fontawesome.com/start) to sign up and create a free icon kit. Then create a file for your environment variables using the included `.env.example` file, then plug it your shiny new kit:

```bash
cd /path/to/your/repo
cp .env.example .env
```

Open `.env` and replace `FONT_AWESOME_KIT_URL` with your kit's url.

### Build and run
You can install dependencies, set up the database, run migrations – etc. etc. – or you can just run the `setup` script:

```bash
cd /path/to/your/repo
bin/setup
```

That's it! Code away my sweet angelic butterfly.

## What's in a Superstack, Exactly?

### Tech stack
Rails Superstack is installed by default with:
* [Ruby on Rails](https://rubyonrails.org)
* [Hotwire](https://hotwired.dev)
* [Postgres](https://www.postgresql.org)
* [Puma](https://puma.io)
* [Rubocop](https://rubocop.org)
* [Tailwind](https://tailwindcss.com)

### Gems and resources
Rails Superstack has been preloaded and configured with the following:
* [Strong Migrations](https://github.com/ankane/strong_migrations) (catch unsafe migrations)
* [LogBench](https://github.com/silva96/log_bench) (log viewer)
* [RSpec](https://rspec.info) + [Factory Bot](https://github.com/thoughtbot/factory_bot_rails) + [Faker](https://github.com/faker-ruby/faker) (testing)
* [Passwordless](https://github.com/mikker/passwordless) (auth)
* [Letter Opener](https://github.com/ryanb/letter_opener) + [web interface](https://github.com/fgrehm/letter_opener_web) (preview emails)
* [Font Awesome](https://fontawesome.com) (icons)

## Linting, Testing, and CI
We've got handy binstubs for RSpec and Rubocop. Local CI will mirror the GitHub workflow that runs when you make commits and merge pull requests.

### Linting
```bash
cd /path/to/your/repo

# Lint code for consistent style
bin/rubocop
```

### Testing
```bash
cd /path/to/your/repo

# Run RSpec tests
bin/rspec
```

### Local CI
```bash
cd /path/to/your/repo
bin/ci
```
