require "rails_helper"

RSpec.describe "GraphQL queries", type: :request do
  describe "macGuffins query" do
    it "returns macguffins ordered by id" do
      user = create(:user)
      mac_guffin_1 = create(:mac_guffin, user:, name: "Ansible", visibility: :open)
      mac_guffin_2 = create(:mac_guffin, user:, name: "Briefcase", visibility: :admin)

      post "/demo/graphql", params: { query: "{ macGuffins { id name visibility userId } }" }

      expect(response).to have_http_status(:ok)
      expect(parsed_body.dig("data", "macGuffins")).to eq(
        [
          {
            "id" => mac_guffin_1.id.to_s,
            "name" => mac_guffin_1.name,
            "visibility" => mac_guffin_1.visibility,
            "userId" => user.id.to_s
          },
          {
            "id" => mac_guffin_2.id.to_s,
            "name" => mac_guffin_2.name,
            "visibility" => mac_guffin_2.visibility,
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
