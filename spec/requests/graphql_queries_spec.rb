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
          { id: user_a.id.to_s, email: user_a.email, role: user_a.role },
          { id: user_b.id.to_s, email: user_b.email, role: user_b.role }
        ]
      )
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
