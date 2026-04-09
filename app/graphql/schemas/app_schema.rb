module GraphQL::Schemas
  # Main GraphQL schema for Health and User queries
  class AppSchema < BaseSchema
    object "Health" do
      field :status, :string, null: false
    end

    object "User" do
      field :id, :id, null: false
      field :email, :string, null: false
      field :role, :string, null: false
    end

    query_fields do
      field(:health, "Health", null: false).resolve { { status: "ok" } }

      field(:users, "User", array: true, null: false)
        .authorize(&require_authentication)
        .resolve {
          User.accessible_by(request.context.current_ability).order(:id)
        }
    end
  end
end
