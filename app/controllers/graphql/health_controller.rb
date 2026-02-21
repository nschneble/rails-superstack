module GraphQL
  class HealthController < ApplicationController
    include Rails::GraphQL::Controller

    self.gql_schema = "GraphQL::Schemas::HealthSchema"

    skip_before_action :verify_authenticity_token
  end
end
