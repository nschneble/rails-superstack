module GraphQL
  class Demo::MacGuffinsController < ApiController
    self.gql_schema = "GraphQL::Schemas::Demo::MacGuffinSchema"

    skip_before_action :verify_authenticity_token
  end
end
