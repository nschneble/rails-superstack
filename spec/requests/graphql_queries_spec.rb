require "rails_helper"

RSpec.describe "GraphQL queries", type: :request do
  describe "users query" do
    it "returns users ordered by id" do
      user_1 = create(:user, email: "alice@example.com")
      user_2 = create(:user, email: "bob@example.com")

      post "/graphql", params: { query: "{ users { id email role } }" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "users")).to eq(
        [
          { "id" => user_1.id.to_s, "email" => user_1.email, "role" => user_1.role },
          { "id" => user_2.id.to_s, "email" => user_2.email, "role" => user_2.role }
        ]
      )
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
