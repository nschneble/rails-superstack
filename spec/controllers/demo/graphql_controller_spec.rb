require "rails_helper"

RSpec.describe Demo::GraphQLController, type: :controller do # rubocop:disable RSpec/SpecFilePathFormat
  include Passwordless::TestHelpers
  include_context "with demo routes"

  describe "GET #show" do
    it "returns ok" do
      get :show
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #execute" do
    it "returns unauthorized when not signed in" do
      post :execute, params: { query: "{ macGuffins { id } }" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig("errors", 0, "message")).to eq("Unauthorized")
    end

    it "returns mac_guffins for an authenticated user" do
      user = create(:user)
      mac_guffin = create(:mac_guffin, user:, visibility: :open)
      passwordless_sign_in(user)

      post :execute, params: { query: "{ macGuffins { id name } }" }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).dig("data", "macGuffins")).to include(
        hash_including("id" => mac_guffin.id.to_s, "name" => mac_guffin.name)
      )
    end
  end
end
