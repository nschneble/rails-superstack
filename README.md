<p align="center">
  <img src="public/icon.png" alt="Rails Superstack" />
  <br />
</p>

# Rails Superstack

Rails Superstack is a ready-to-go Ruby on Rails instance with front-end, database, and accouterments. **A majestic monolith with a f\*ckton of useful gems.** It's a free public template anyone can use to hit the ground running with their own app ideas.

[![CI](https://github.com/nschneble/rails-superstack/actions/workflows/ci.yml/badge.svg)](https://github.com/nschneble/rails-superstack/actions/workflows/ci.yml) [![License: CC0-1.0](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](http://creativecommons.org/publicdomain/zero/1.0)

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Run Rename Script](#run-rename-script)
  - [Set Up Font Awesome](#set-up-font-awesome)
  - [Build and Run](#build-and-run)
- [What's in a Superstack, Exactly?](#whats-in-a-superstack-exactly)
  - [Tech Stack](#tech-stack)
  - [Gems and Resources](#gems-and-resources)
  - [Code Features](#code-features)
  - [Routes](#routes)
     - [User Routes](#user-routes)
     - [Admin Routes](#admin-routes)
     - [Demo Routes](#demo-routes)
- [Linting, Testing, and CI](#linting-testing-and-ci)
  - [Linting](#linting)
  - [Testing](#testing)
  - [Local CI](#local-ci)
- [GraphQL API](#graphql-api)
  - [Getting Auth Tokens](#getting-auth-tokens)
     - [In Rails](#in-rails)
     - [In Terminal](#in-terminal)
  - [Making Queries](#making-queries)
- [Ephemera](#ephemera)
  - [Cleanup Script](#cleanup-script)
- [Acknowledgements](#acknowledgements)

## Getting Started

First things first. [Create a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template#creating-a-repository-from-a-template) from this template. It's only two steps!

1. Click on "Use this template" above the file list
2. Select "Create a new repository"

Clone the new repo to your local machine, and you're done! (I suppose that's _technically_ three steps)

### Prerequisites

With your shiny new repo in hand, here's what you need to get cooking:

- [Bundler](https://bundler.io/) 2.7.2
- PostgreSQL 18.1
- Redis 8.4.1
- Ruby 3.4.7
- Typesense 30.1

I'd personally recommend [Homebrew](https://brew.sh) and [rbenv](https://rbenv.org) to install these prerequisites:

```bash
cd /path/to/your/repo

# Install Homebrew + Postgres
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install postgresql@18

# Install Redis + Typesense
brew install redis
brew install typesense/tap/typesense-server@30.1

# Install rbenv + Ruby
curl -fsSL https://rbenv.org/install.sh | bash
rbenv install 3.4.7

# Install Bundler
gem install bundler -v 2.7.2

# start up the services
brew services start postgresql@18
brew services start redis
brew services start typesense-server@30.1
```

### Run Rename Script

Unless you want your app to be called "Rails Superstack", you'll probably want to run this script:

```bash
cd /path/to/your/repo

# Get help
script/rename.sh —help

# Preview changes
script/rename.sh --dry-run

# Run interactively
script/rename.sh

# Run without prompts
script/rename.sh --no-confirmation
```

The script should be clever enough to detect your new repo's origin url. If not, it'll prompt you for it. If _that_ fails, it'll prompt for your GitHub username and repository name.

After the script runs successfully, it'll delete itself and create a new README.

### Set Up Font Awesome

This one's easy. Navigate to [Get Started with Font Awesome](https://fontawesome.com/start) to sign up and add a new icon kit. Create a file for your environment variables using the included `.env.example` file, then plug in your shiny new kit:

```bash
cd /path/to/your/repo
cp .env.example .env
```

Open `.env` and replace `FONT_AWESOME_KIT_URL` with your kit's url.

### Build and Run

You can install dependencies, set up the database, run migrations – etc. etc. – or you can live on the wild side and run the `setup` script:

```bash
cd /path/to/your/repo
bin/setup
```

Done this song-and-dance before? If you just need to start up the development server, you can skip straight to the end and run the `dev` script:

```bash
cd /path/to/your/repo
bin/dev
```

Open [localhost:3000](http://localhost:3000) in your web browser and you're good to go!

## What's in a Superstack, Exactly?

### Tech Stack

Rails Superstack is installed by default with:

- [Ruby on Rails](https://rubyonrails.org)
- [Hotwire](https://hotwired.dev)
- [Postgres](https://www.postgresql.org)
- [Puma](https://puma.io)
- [RuboCop](https://rubocop.org)
- [Tailwind](https://tailwindcss.com)

### Gems and Resources

Rails Superstack has been preloaded and configured with the following:

- [Strong Migrations](https://github.com/ankane/strong_migrations) (catch unsafe migrations)
- [LogBench](https://github.com/silva96/log_bench) (log viewer)
- [RSpec](https://rspec.info) + [Factory Bot](https://github.com/thoughtbot/factory_bot_rails) + [Faker](https://github.com/faker-ruby/faker) (testing)
- [Passwordless](https://github.com/mikker/passwordless) + [CanCanCan](https://github.com/CanCanCommunity/cancancan) (auth, roles)
- [Letter Opener](https://github.com/ryanb/letter_opener) + [Letter Opener Web](https://github.com/fgrehm/letter_opener_web) (preview emails)
- [Pom Component](https://pom-io.github.io/pom-component) (view components)
- [Font Awesome](https://fontawesome.com) + [Gravatar Image Tag Plugin](https://github.com/mdeering/gravatar_image_tag) (icons)
- [SuperAdmin](https://github.com/ThibautBaissac/super_admin) + [Flipper](https://www.flippercloud.io) (admin + feature flags)
- [Commonmarker](https://github.com/gjtorikian/commonmarker) (syntax highlighting)
- [Resque](http://resque.github.io) (background jobs)
- [Typesense](https://typesense.org) + [Pagy](https://ddnexus.github.io/pagy) (search + pagination)
- [GraphQL](https://rails-graphql.dev) (API)
- [Noticed](https://github.com/excid3/noticed) (notifications)

### Code Features

| Feature           | Description                               |
| ----------------- | ----------------------------------------- |
| Abilities (Roles) | [Ability](app/models/ability.rb)          |
| Models            | [User](app/models/user.rb)                |
| Helpers           | Text, web urls, forms, Font Awesome icons |
| Normalizers       | Email addresses                           |
| Validators        | Email addresses, web urls                 |
| View Components   | Clipboard, flash alerts, code snippets    |

### Routes

#### User Routes

| Endpoint     | Description                     |
| ------------ | ------------------------------- |
| `/sign_in`   | Sign in as a new user           |
| `/sign_out`  | Sign out the current user       |
| `/profile`   | Set current user email          |
| `/sent_mail` | Preview sent mail (login codes) |

#### Admin Routes

| Endpoint   | Description           |
| ---------- | --------------------- |
| `/admin`   | SuperAdmin dashboard  |
| `/flipper` | Flipper feature flags |
| `/resque`  | Resque jobs           |

#### Demo Routes

(The [cleanup script](#cleanup-script) will remove these endpoints)

| Endpoint            | Description                            |
| ------------------- | -------------------------------------- |
| `/demo/welcome`     | Starter page with helpful links        |
| `/demo/alert`       | Example for flash alerts               |
| `/demo/notice`      | Example for flash notices              |
| `/demo/mac_guffins` | Items accessible by current user       |
| `/demo/secrets`     | A "secret" route behind a feature flag |
| `/demo/terminal`    | Lists useful terminal commands         |

## Linting, Testing, and CI

There's handy binstubs for RSpec and RuboCop. Local CI will mirror the GitHub workflow that runs when you make commits and merge pull requests.

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

## GraphQL API

GraphQL is a touch different than your vanilla JSON API. The data structures are effectively dynamic, so you can hit a single endpoint to request any sort of data in any sort of order.

An endpoint covers a single GraphQL schema, which could compromise an individual model or literally your entire database. For simplicity and clarify, this repo has three schemas: one for the unauthenticated health check, one for users, and a demo one for MacGuffins.

[Learn more about GraphQL](https://graphql.org/learn/)

### Getting Auth Tokens

The API uses token-based authentication. You'll need a bearer authentication token to make queries to authenticated endpoints.

#### In Rails

You can use `ApiToken.issue!(user:, name:)` to get a bearer auth token in Rails. Pass in `current_user` to query resources available in the current session.

#### In Terminal

There's a one-stop binstub to pipe a bearer auth token directly into your GraphQL queries:

```bash
cd /path/to/your/repo

# Returns "Bearer TOKEN" for direct usage
bin/api-token api@superstack.dev
```

### Making Queries

To query data in GraphQL, you `POST` to an endpoint with your `query` as the payload. The examples below use `curl` to hit the API and pipe the responses to `jq` for pretty formatting in the terminal.

```bash
cd /path/to/your/repo

# health check
curl -s -H 'Content-Type: application/json' \
  -X POST http://localhost:3000/graphql/health \
  -d '{"query":"{ apiHealth { status } }"}' | jq

# users
# requires authentication
bin/api-token | xargs -I% curl -s -H 'Content-Type: application/json' \
  -H 'Authorization: %' \
  -X POST http://localhost:3000/graphql \
  -d '{"query":"{ users { id email role } }"}' | jq

# MacGuffins
# requires authentication
bin/api-token | xargs -I% curl -s -H 'Content-Type: application/json' \
  -H 'Authorization: %' \
  -X POST http://localhost:3000/demo/graphql \
  -d '{"query":"{ macGuffins { id name description } }"}' | jq
```

A response will be nicely formatted JSON data:

```json
# POST /graphql/health
{
  "data": {
    "apiHealth": {
      "status": "ok"
    }
  }
}
```

## Ephemera

### Cleanup Script

Dislike the demo code with a passion? Easy! Burn it with 🔥 fire 🔥 by running the cleanup script:

```bash
cd /path/to/your/repo

# Get help
script/wipedemo.sh —help

# Preview changes
script/wipedemo.sh --dry-run

# Run interactively
script/wipedemo.sh

# Run without prompts
script/wipedemo.sh --no-confirmation
```

The script should remove all trace of demo code: assets, controllers, models, views, routes, seeds, factories, and specs.

After the script runs successfully, it'll delete itself and you’ll be left with a pristine Superstack template.

## Acknowledgements

The Rails Superstack logo was crafted from an illustration by [Muhammad Afandi](https://unsplash.com/@kertiaa?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/illustrations/three-stacked-geometric-shapes-on-white-background-VxU_akYKA8Q?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).
