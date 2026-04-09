require "ostruct"
require "simplecov"
require "simplecov_badger"
require "simplecov-tailwindcss"

require_relative "../app/helpers/simplecov/formatter/custom_formatter"

SimpleCov.start do
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::TailwindFormatter,
    SimpleCov::Formatter::CustomFormatter,
    SimpleCov::Badger::Formatter
  ])

  Warning.prepend(
    Module.new do
      def warn(message, category: nil)
        super unless message.include?("exceeds number of lines")
      end
    end
  )

  load_profile "test_frameworks"

  add_filter %r{^/app/dashboards/}
  add_filter %r{^/app/helpers/simplecov/}
  add_filter %r{^/config/}
  add_filter %r{^/db/}
  add_filter "/demo/"

  add_group "Components", "app/components"
  add_group "Controllers", "app/controllers"
  add_group "Decorators", "app/decorators"
  add_group "GraphQL", "app/graphql"
  add_group "Helpers", "app/helpers"
  add_group "Jobs", "app/jobs"
  add_group "Libraries", "lib"
  add_group "Mailers", "app/mailers"
  add_group "Models", "app/models"
  add_group "Normalizers", "app/normalizers"
  add_group "Notifiers", "app/notifiers"
  add_group "Parsers", "app/parsers"
  add_group "Services", "app/services"
  add_group "Validators", "app/validators"
  add_group "Views", "app/views"

  enable_coverage :branch
  enable_coverage_for_eval

  track_files "{app,lib}/**/*.rb"
  coverage_dir "simplecov"
end
