module GraphQL
  class UsersController < ApiController
    self.gql_schema = "GraphQL::Schemas::UserSchema"
  end
end
