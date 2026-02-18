class GraphQL::Demo::MacGuffinsController < ApplicationController
  include Rails::GraphQL::Controller

  self.gql_schema = "GraphQL::Schemas::Demo::MacGuffinSchema"

  skip_before_action :verify_authenticity_token
end
