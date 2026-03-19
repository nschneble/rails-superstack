class Demo::GraphQLController < ApplicationController
  include Rails::GraphQL::Controller

  layout "demo/moxie"

  skip_before_action :verify_authenticity_token, except: %i[show]

  self.gql_schema = "GraphQL::Schemas::Demo::AppSchema"

  # app/views/demo/graphql/show.html.erb
  def show; end

  protected

  def gql_context
    super.merge(current_user:, current_ability:)
  end
end
