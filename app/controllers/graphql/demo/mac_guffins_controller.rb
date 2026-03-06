module GraphQL
  class Demo::MacGuffinsController < ApiController
    self.gql_schema = "GraphQL::Schemas::Demo::MacGuffinSchema"
  end
end
