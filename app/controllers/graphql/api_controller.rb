class GraphQL::ApiController < ApplicationController
  include Rails::GraphQL::Controller
  include ApiAuthentication
end
