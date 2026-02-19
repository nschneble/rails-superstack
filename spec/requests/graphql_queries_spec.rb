require "rails_helper"

RSpec.describe "GraphQL queries", type: :request do
  describe "authentication" do
    it "returns 'unauthorized' when no session or bearer token is provided" do
      post "/graphql", params: { query: "{ users { id } }" }

      expect(response).to have_http_status(:unauthorized)
      expect(parsed_body).to eq(
        "errors" => [ { "message" => "Unauthorized" } ]
      )
    end
  end

  describe "User queries" do
    it "returns users (ordered by id) for an authenticated Passwordless session" do
      user_a = create(:user)
      user_b = create(:user)

      passwordless_sign_in(user_a)
      post "/graphql", params: { query: "{ users { id email role } }" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "users")).to eq(
        [
          { "id" => user_a.id.to_s, "email" => user_a.email, "role" => user_a.role },
          { "id" => user_b.id.to_s, "email" => user_b.email, "role" => user_b.role }
        ]
      )
    end

    it "returns users (ordered by id) for token authentication" do
      user_a = create(:user)
      user_b = create(:user)

      token = ApiToken.issue!(user: user_a, name: "Spec Token")

      post "/graphql",
        params: { query: "{ users { id email role } }" },
        headers: { Authorization: "Bearer #{token.plaintext_token}" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "users")).to eq(
        [
          { "id" => user_a.id.to_s, "email" => user_a.email, "role" => user_a.role },
          { "id" => user_b.id.to_s, "email" => user_b.email, "role" => user_b.role }
        ]
      )
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
