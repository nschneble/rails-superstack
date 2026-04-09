module Demo
  # Demo GraphQL endpoint and interactive GraphiQL explorer page
  class GraphQLController < DemoApplicationController
    include Rails::GraphQL::Controller

    skip_before_action :verify_authenticity_token, only: %i[execute]

    self.gql_schema = "GraphQL::Schemas::Demo::AppSchema"

    # app/views/demo/graphql/show.html.erb
    def show; end

    protected

    def gql_context
      super.merge(current_user:, current_ability:)
    end
  end
end
