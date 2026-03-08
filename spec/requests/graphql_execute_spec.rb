require "rails_helper"

RSpec.describe "GraphQL execute", type: :request do
  describe "authentication" do
    it "returns 'unauthorized' when there's no session or bearer token" do
      post "/graphql", params: { query: "{ users { id } }" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("errors", 0, "message")).to eq("Unauthorized")
      expect(parsed_body.dig("data", "users")).to be_nil
    end
  end

  describe "Health query" do
    context "without authentication" do
      it "returns ok" do
        post "/graphql", params: { query: "{ health { status } }" }

        expect(response).to have_http_status(:ok)
        expect(parsed_body).to eq("data" => { "health" => { "status" => "ok" } })
      end
    end
  end

  describe "User query" do
    context "with session authentication" do
      it "returns users ordered by id" do
        user_a = create(:user)
        user_b = create(:user)

        passwordless_sign_in(user_a)
        post "/graphql", params: { query: "{ users { id email role } }" }

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to include(
          { "id" => user_a.id.to_s, "email" => user_a.email, "role" => user_a.role },
          { "id" => user_b.id.to_s, "email" => user_b.email, "role" => user_b.role }
        )
      end

      it "excludes admins when authenticated user is not an admin" do
        user = create(:user)
        admin = create(:user, :admin)

        passwordless_sign_in(user)
        post "/graphql", params: { query: "{ users { id email role } }" }

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to include(
          { "id" => user.id.to_s, "email" => user.email, "role"  => user.role }
        )
      end
    end

    context "with token authentication" do
      it "returns users ordered by id" do
        user_a = create(:user)
        user_b = create(:user)

        token = ApiToken.issue!(user: user_a, name: "Spec Token")

        post "/graphql",
          params: { query: "{ users { id email role } }" },
          headers: { Authorization: "Bearer #{token.plaintext_token}" }

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to include(
          { "id" => user_a.id.to_s, "email" => user_a.email, "role" => user_a.role },
          { "id" => user_b.id.to_s, "email" => user_b.email, "role" => user_b.role }
        )
      end

      it "includes admins when authenticated user is an admin" do
        user = create(:user, :admin)
        admin = create(:user, :admin)

        token = ApiToken.issue!(user:, name: "Admin Spec Token")

        post "/graphql",
          params: { query: "{ users { id email role } }" },
          headers: { Authorization: "Bearer #{token.plaintext_token}" }

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to include(
          { "id" => user.id.to_s, "email" => user.email, "role" => user.role },
          { "id" => admin.id.to_s, "email" => admin.email, "role" => admin.role }
        )
      end
    end
  end

  private

  def parsed_body
    JSON.parse(response.body)
  end
end
