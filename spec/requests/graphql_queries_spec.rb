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

  describe "Health queries" do
    it "returns ok without authentication" do
      post "/graphql/health", params: { query: "{ apiHealth { status } }" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body).to eq(
        "data" => {
          "apiHealth" => { "status" => "ok" }
        }
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

    it "excludes admins in queries by non-admin users" do
      user = create(:user)
      admin = create(:user, :admin)

      passwordless_sign_in(user)
      post "/graphql", params: { query: "{ users { id email role } }" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "users")).to eq(
        [
          {
            "id"    => user.id.to_s,
            "email" => user.email,
            "role"  => user.role
          }
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

    it "returns users and admins in admin queries" do
      user = create(:user)
      admin = create(:user, :admin)

      token = ApiToken.issue!(user: admin, name: "Admin Spec Token")

      post "/graphql",
        params: { query: "{ users { id email role } }" },
        headers: { Authorization: "Bearer #{token.plaintext_token}" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "users")).to eq(
        [
          { "id" => user.id.to_s,  "email" => user.email,  "role" => user.role },
          { "id" => admin.id.to_s, "email" => admin.email, "role" => admin.role }
        ]
      )
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
