class Demo::GraphQLController < ApplicationController
  include Rails::GraphQL::Controller

  skip_before_action :verify_authenticity_token

  self.gql_schema = "GraphQL::Schemas::Demo::AppSchema"

  protected

  def gql_context
    super.merge(current_user:, current_ability:)
  end
end
