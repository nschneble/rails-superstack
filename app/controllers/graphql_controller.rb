# Serves GraphQL API endpoints, supporting multiple schemas and GraphiQL

class GraphQLController < ApplicationController
  include Rails::GraphQL::Controller
  include Schemable

  protect_from_forgery with: :exception, unless: :csrf_exempt_graphql_request?

  self.gql_schema = "GraphQL::Schemas::AppSchema"

  def describe
    super(current_config.fetch(:schema))
  end

  protected

  # :reek:ControlParameter — it's a standard Rails override guard clause
  def graphiql_settings(mode = nil)
    return super if mode == :cable

    { mode: :fetch, url: current_config.fetch(:execute_path) }
  end

  def gql_context
    super.merge(current_user:, current_ability:)
  end

  private

  def csrf_exempt_graphql_request?
    bearer_token.present? || authenticate_by_session(User).blank? || request.content_type&.include?("application/json")
  end
end
