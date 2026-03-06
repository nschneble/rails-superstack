class GraphQL::ApiController < AuthenticatedController
  include Rails::GraphQL::Controller

  skip_before_action :verify_authenticity_token

  # ensures we receive the correct authentication responses
  def browser_auth_request?
    false
  end
end
