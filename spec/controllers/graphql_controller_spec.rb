require "rails_helper"

RSpec.describe GraphQLController, type: :controller do # rubocop:disable RSpec/SpecFilePathFormat
  include Passwordless::TestHelpers

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

  describe "#csrf_exempt_graphql_request?" do
    it "returns false for a session-authenticated non-JSON request without bearer token" do
      user = create(:user)
      allow(controller).to receive(:bearer_token).and_return(nil)
      allow(controller).to receive(:authenticate_by_session).and_return(user)
      request.env["CONTENT_TYPE"] = "text/html"
      expect(controller.send(:csrf_exempt_graphql_request?)).to be(false)
    end

    it "returns true for an unauthenticated request with no bearer token" do
      allow(controller).to receive(:bearer_token).and_return(nil)
      allow(controller).to receive(:authenticate_by_session).and_return(nil)
      expect(controller.send(:csrf_exempt_graphql_request?)).to be(true)
    end

    it "returns falsy for a session-authenticated request with no content type and no bearer token" do
      user = create(:user)
      allow(controller).to receive(:bearer_token).and_return(nil)
      allow(controller).to receive(:authenticate_by_session).and_return(user)
      expect(controller.send(:csrf_exempt_graphql_request?)).to be_falsy
    end
  end

  describe "#graphiql_settings" do
    it "returns cable settings when mode is :cable" do
      result = controller.send(:graphiql_settings, :cable)
      expect(result[:mode]).to eq(:cable)
    end

    it "returns fetch settings with the configured execute path for other modes" do
      allow(controller).to receive(:current_config).and_return({ execute_path: "/graphql" })
      result = controller.send(:graphiql_settings)
      expect(result).to eq({ mode: :fetch, url: "/graphql" })
    end
  end
end
