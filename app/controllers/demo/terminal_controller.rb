module Demo
  class TerminalController < ApplicationController
    layout "demo/moxie"

    def show
      @commands = [
        TerminalCommand.new(
          code: "log_bench log/development.log",
          icon: "satellite-dish",
          name: "log_bench",
          text: 'Try out <a class="hover:text-amber-400 underline!" href="https://github.com/silva96/log_bench">LogBench</a><span class="hidden sm:inline"> for some real-time monitoring</span>'
        ),
        TerminalCommand.new(
          code: "bin/rubocop",
          icon: "spell-check",
          name: "rubocop",
          text: 'Lint <span class="hidden sm:inline">and format your code</span> with <a class="hover:text-amber-400 underline!" href="https://rubocop.org/">RuboCop</a>'
        ),
        TerminalCommand.new(
          code: "bin/rspec",
          icon: "microscope",
          name: "rspec",
          text: 'Run <a class="hover:text-amber-400 underline!" href="https://rspec.info/">RSpec</a><span class="hidden sm:inline"> tests with <a class="hover:text-amber-400 underline!" href="https://github.com/thoughtbot/factory_bot_rails">Factory Bot</a> and <a class="hover:text-amber-400 underline!" href="https://github.com/faker-ruby/faker">Faker</a></span>'
        ),
        TerminalCommand.new(
          code: "bin/ci",
          icon: "code-merge",
          name: "ci",
          text: '<span class="hidden sm:inline">Ready to merge? </span><a class="hover:text-amber-400 underline!" href="https://github.com/nschneble/rails-superstack?tab=readme-ov-file#linting-testing-and-ci">Run local CI</a>'
        )
      ]
    end
  end
end
