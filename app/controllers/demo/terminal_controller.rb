module Demo
  # Renders the CLI command reference guide for the demo terminal page
  class TerminalController < DemoApplicationController
    def show
      @commands = [
        TerminalCommand.new(
          icon: "satellite-dish",
          name: "log_bench",
          code: "log_bench log/development.log",
          description: [
            "Try out",
            { link: "LogBench", to: "https://github.com/silva96/log_bench" },
            { hidden: [ "for some real-time monitoring" ] }
          ]
        ),
        TerminalCommand.new(
          icon: "spell-check",
          name: "rubocop",
          code: "bin/rubocop",
          description: [
            "Lint",
            { hidden: [ "and format your code" ] },
            "with",
            { link: "RuboCop", to: "https://rubocop.org/" }
          ]
        ),
        TerminalCommand.new(
          icon: "poo",
          name: "rubycritic",
          code: "bin/rubycritic",
          description: [
            "Check code quality with",
            { link: "RubyCritic", to: "https://github.com/whitesmith/rubycritic" }
          ]
        ),
        TerminalCommand.new(
          icon: "vial-circle-check",
          name: "rspec",
          code: "bin/rspec",
          description: [
            "Run",
            { link: "RSpec", to: "https://rspec.info/" },
            { hidden: [
              " tests with",
              { link: "Factory Bot", to: "https://github.com/thoughtbot/factory_bot_rails" },
              "and",
              { link: "Faker", to: "https://github.com/faker-ruby/faker" }
            ] }
          ]
        ),
        TerminalCommand.new(
          icon: "code-merge",
          name: "ci",
          code: "bin/ci",
          description: [
            { hidden: [ "Ready to merge?" ] },
            { link: "Run local CI", to: "https://github.com/nschneble/rails-superstack?tab=readme-ov-file#linting-testing-and-ci" }
          ]
        )
      ].map(&:decorate)
    end
  end
end
