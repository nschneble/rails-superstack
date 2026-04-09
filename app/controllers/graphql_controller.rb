# Serves GraphQL API endpoints, supporting multiple schemas and GraphiQL

class GraphQLController < ApplicationController
  include Rails::GraphQL::Controller
  include Schemable

  skip_before_action :verify_authenticity_token

  self.gql_schema = "GraphQL::Schemas::AppSchema"

  def describe
    super(current_config.fetch(:schema))
  end

  protected

  # :reek:ControlParameter — standard Rails override guard clause; mode distinguishes cable from fetch
  def graphiql_settings(mode = nil)
    return super if mode == :cable

    { mode: :fetch, url: current_config.fetch(:execute_path) }
  end

  def gql_context
    super.merge(current_user:, current_ability:)
  end
end
