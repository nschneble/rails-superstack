module GraphQL
  class UsersController < ApiController
    self.gql_schema = "GraphQL::Schemas::UserSchema"

    skip_before_action :verify_authenticity_token
  end
end
