require "rails_helper"

RSpec.describe "GraphQL describe", type: :request do
  before do
    passwordless_sign_in(create(:user))
  end

  describe "GET /graphiql" do
    it "renders the GraphiQL interface" do
      get "/graphiql"
      expect(response).to have_http_status(:ok)
    end

    it "delegates graphiql_settings to super in cable mode" do
      ctrl = GraphQLController.new
      result = ctrl.send(:graphiql_settings, :cable)
      expect(result).to include(mode: :cable)
    end
  end

  describe "GET /graphql/describe" do
    it "defaults to app schema" do
      get "/graphql/describe"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("# Schema GraphQL::Schemas::AppSchema")
    end

    it "supports explicitly selecting a schema" do
      get "/graphql/describe", params: { schema: "graphql" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("# Schema GraphQL::Schemas::AppSchema")
    end

    it "rejects unsupported schemas" do
      get "/graphql/describe", params: { schema: "nassau" }

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include("Unknown schema 'nassau'")
    end
  end
end
