require "rails_helper"

RSpec.describe "GraphQL demo queries", type: :request do
  describe "MacGuffin queries" do
    it "returns MacGuffins ordered by id for token authentication" do
      user = create(:user)
      mac_guffin_a = create(:mac_guffin, :food, :user, user:)
      mac_guffin_b = create(:mac_guffin, user:, visibility: :admin)

      token = ApiToken.issue!(user:, name: "Spec Token")

      post "/demo/graphql",
        params: { query: "{ macGuffins { id name visibility userId } }" },
        headers: { Authorization: "Bearer #{token.plaintext_token}" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "macGuffins")).to eq(
        [
          {
            "id" => mac_guffin_a.id.to_s,
            "name" => mac_guffin_a.name,
            "visibility" => mac_guffin_a.visibility,
            "userId" => user.id.to_s
          },
          {
            "id" => mac_guffin_b.id.to_s,
            "name" => mac_guffin_b.name,
            "visibility" => mac_guffin_b.visibility,
            "userId" => user.id.to_s
          }
        ]
      )
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
