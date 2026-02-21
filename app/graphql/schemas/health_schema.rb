class GraphQL::Schemas::HealthSchema < GraphQL::Schema
  namespace :health

  object "ApiHealthCheck" do
    field :status, :string, null: false
  end

  query_fields do
    field(:api_health, "ApiHealthCheck", null: false).resolve { { status: "ok" } }
  end
end
