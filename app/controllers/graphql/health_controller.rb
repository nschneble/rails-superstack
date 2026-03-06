module GraphQL
  class HealthController < ApiController
    self.gql_schema = "GraphQL::Schemas::HealthSchema"

    skip_before_action :authenticate_user!
  end
end
