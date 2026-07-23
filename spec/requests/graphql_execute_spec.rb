require "rails_helper"

RSpec.describe "GraphQL execute", type: :request do
  describe "authentication" do
    it "returns 'unauthorized' when there's no session or bearer token" do
      post "/graphql", params: { query: "{ users { id } }" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("errors", 0, "message")).to eq("Unauthorized")
      expect(parsed_body.dig("data", "users")).to be_nil
    end

    it "returns 'unauthorized' when the bearer token is invalid" do
      post "/graphql",
        params: { query: "{ users { id } }" },
        headers: { Authorization: "Bearer invalid_token_xyz" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("errors", 0, "message")).to eq("Unauthorized")
    end
  end

  describe "Health query" do
    context "without authentication" do
      it "returns ok" do
        post "/graphql", params: { query: "{ health { status } }" }

        expect(response).to have_http_status(:ok)
        expect(parsed_body).to eq("data" => { "health" => { "status" => "ok" } })
      end

      it "still returns ok with forgery protection enabled" do
        with_forgery_protection do
          post "/graphql", params: { query: "{ health { status } }" }
        end

        expect(response).to have_http_status(:ok)
        expect(parsed_body).to eq("data" => { "health" => { "status" => "ok" } })
      end
    end
  end

  describe "User query" do
    context "with session authentication" do
      it "requires a CSRF token" do
        user = create(:user)

        passwordless_sign_in(user)
        with_forgery_protection do
          post "/graphql", params: { query: "{ users { id email role } }" }
        end

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns only the signed-in user's own record" do
        user_a = create(:user)
        create(:user) # another user must exist to prove they're excluded

        passwordless_sign_in(user_a)

        with_forgery_protection do
          post "/graphql",
            params: { query: "{ users { id email role } }" },
            headers: { "X-CSRF-Token" => fetch_csrf_token }
        end

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to contain_exactly(
          { "id" => user_a.id.to_s, "email" => user_a.email, "role" => user_a.role }
        )
      end

      it "excludes admins when authenticated user is not an admin" do
        user = create(:user)
        create(:user, :admin) # an admin must exist to prove they're excluded

        passwordless_sign_in(user)

        with_forgery_protection do
          post "/graphql",
            params: { query: "{ users { id email role } }" },
            headers: { "X-CSRF-Token" => fetch_csrf_token }
        end

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to contain_exactly(
          { "id" => user.id.to_s, "email" => user.email, "role"  => user.role }
        )
      end
    end

    context "with token authentication" do
      it "returns only the token-owning user's own record" do
        user_a = create(:user)
        create(:user) # another user must exist to prove they're excluded

        token = ApiToken.issue!(user: user_a, name: "Spec Token")

        with_forgery_protection do
          post "/graphql",
            params: { query: "{ users { id email role } }" },
            headers: { Authorization: "Bearer #{token.plaintext_token}" }
        end

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to contain_exactly(
          { "id" => user_a.id.to_s, "email" => user_a.email, "role" => user_a.role }
        )
      end

      it "includes admins when authenticated user is an admin" do
        user = create(:user, :admin)
        admin = create(:user, :admin)

        token = ApiToken.issue!(user:, name: "Admin Spec Token")

        with_forgery_protection do
          post "/graphql",
            params: { query: "{ users { id email role } }" },
            headers: { Authorization: "Bearer #{token.plaintext_token}" }
        end

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users")).to include(
          { "id" => user.id.to_s, "email" => user.email, "role" => user.role },
          { "id" => admin.id.to_s, "email" => admin.email, "role" => admin.role }
        )
      end

      it "caps the number of returned users at 100" do
        user = create(:user, :admin)
        create_list(:user, 101) # rubocop:disable FactoryBot/ExcessiveCreateList -- must exceed the cap under test

        token = ApiToken.issue!(user:, name: "Admin Spec Token")

        with_forgery_protection do
          post "/graphql",
            params: { query: "{ users { id } }" },
            headers: { Authorization: "Bearer #{token.plaintext_token}" }
        end

        expect(response).to have_http_status(:ok)
        expect(parsed_body.dig("data", "users").size).to eq(100)
      end
    end
  end

  private

  def fetch_csrf_token
    get root_path
    response.body.match(/<meta name="csrf-token" content="([^"]+)"/).captures.first
  end

  def parsed_body
    JSON.parse(response.body)
  end

  def with_forgery_protection
    original = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    yield
  ensure
    ActionController::Base.allow_forgery_protection = original
  end
end
