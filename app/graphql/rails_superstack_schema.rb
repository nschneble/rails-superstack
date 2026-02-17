# frozen_string_literal: true

module GraphQL
  class RailsSuperstackSchema < GraphQL::Schema
    field(:welcome).resolve { "Hello World!" }
  end
end
