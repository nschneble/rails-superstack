# frozen_string_literal: true

class GraphQL::UsersController < ApplicationController
  include Rails::GraphQL::Controller

  self.gql_schema = "GraphQL::Schemas::UserSchema"

  skip_before_action :verify_authenticity_token
end
