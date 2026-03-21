module Demo
  class TerminalController < ApplicationController
    layout "demo/moxie"

    def show
      @commands = [
        TerminalCommand.new(
          code: "log_bench log/development.log",
          icon: "satellite-dish",
          name: "log_bench",
          description: [
            "Try out",
            { link: "LogBench", to: "https://github.com/silva96/log_bench" },
            { hidden: ["for some real-time monitoring"] }
          ]
        ),
        TerminalCommand.new(
          code: "bin/rubocop",
          icon: "spell-check",
          name: "rubocop",
          description: [
            "Lint",
            { hidden: ["and format your code"] },
            "with",
            { link: "RuboCop", to: "https://rubocop.org/" }
          ]
        ),
        TerminalCommand.new(
          code: "bin/rspec",
          icon: "microscope",
          name: "rspec",
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
          code: "bin/ci",
          icon: "code-merge",
          name: "ci",
          description: [
            { hidden: ["Ready to merge?"] },
            { link: "Run local CI", to: "https://github.com/nschneble/rails-superstack?tab=readme-ov-file#linting-testing-and-ci" }
          ]
        )
      ]
    end
  end
end
