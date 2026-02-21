require "rails_helper"

RSpec.describe "GraphQL demo queries", type: :request do
  describe "MacGuffin queries" do
    it "returns MacGuffins ordered by id for token authentication" do
      user = create(:user)
      mac_guffin_a = create(:mac_guffin, :food, :user, user:)
      mac_guffin_b = create(:mac_guffin, user:, visibility: :admin)

      token = ApiToken.issue!(user:, name: "Spec Token")

      post "/demo/graphql",
        params: { query: "{ macGuffins { id name } }" },
        headers: { Authorization: "Bearer #{token.plaintext_token}" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "macGuffins")).to eq(
        [
          {
            "id"   => mac_guffin_a.id.to_s,
            "name" => mac_guffin_a.name
          },
          {
            "id"   => mac_guffin_b.id.to_s,
            "name" => mac_guffin_b.name
          }
        ]
      )
    end

    it "scopes MacGuffins by CanCanCan rules" do
      user_a = create(:user)
      user_b = create(:user, :admin)

      mac_guffin_a = create(:mac_guffin, user: user_a, visibility: :open)
      mac_guffin_b = create(:mac_guffin, user: user_b, visibility: :open)
      mac_guffin_c = create(:mac_guffin, user: user_b, visibility: :user)
      mac_guffin_d = create(:mac_guffin, user: user_b, visibility: :admin)

      token = ApiToken.issue!(user: user_a, name: "Spec Token")

      post "/demo/graphql",
        params: { query: "{ macGuffins { id name } }" },
        headers: { Authorization: "Bearer #{token.plaintext_token}" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "macGuffins")).to eq(
        [
          {
            "id"   => mac_guffin_a.id.to_s,
            "name" => mac_guffin_a.name
          },
          {
            "id"   => mac_guffin_b.id.to_s,
            "name" => mac_guffin_b.name
          },
          {
            "id"   => mac_guffin_c.id.to_s,
            "name" => mac_guffin_c.name
          }
        ]
      )
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end
end
