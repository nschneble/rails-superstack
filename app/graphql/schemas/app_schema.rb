# Main GraphQL schema for Health and User queries

class GraphQL::Schemas::AppSchema < GraphQL::Schema
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
      .authorize { |event|
        return event.authorized! if event.context.current_user

        event.unauthorized!(message: I18n.t("api.authentication.unauthorized"))
      }
      .resolve {
        User.accessible_by(request.context.current_ability).order(:id)
      }
  end
end
