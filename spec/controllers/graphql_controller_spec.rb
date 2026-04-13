require "rails_helper"

RSpec.describe GraphQLController, type: :controller do # rubocop:disable RSpec/SpecFilePathFormat
  before do
    Rails.application.routes.draw do
      get "/graphiql",          to: "graphql#graphiql",  as: :graphiql
      get "/graphql/describe",  to: "graphql#describe",  as: :graphql_describe
      post "/graphql",          to: "graphql#execute",   as: :graphql
    end
  end

  after { Rails.application.reload_routes! }

  describe "GET #describe" do
    it "returns the schema description" do
      get :describe, params: { schema: "graphql" }
      expect(response).to have_http_status(:ok)
    end

    it "raises BadRequest for unknown schema names" do
      expect {
        get :describe, params: { schema: "nonexistent" }
      }.to raise_error(ActionController::BadRequest)
    end
  end

  describe "GET #graphiql" do
    it "returns ok" do
      get :graphiql
      expect(response).to have_http_status(:ok)
    end
  end
end
