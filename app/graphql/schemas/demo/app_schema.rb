# Demo GraphQL schema for MacGuffin queries

class GraphQL::Schemas::Demo::AppSchema < GraphQL::Schema
  namespace :demo

  object "MacGuffin" do
    field :id, :id, null: false
    field :name, :string
    field :description, :string
    field :visibility, :string
    field :user_id, :id, null: false
  end

  query_fields do
    field(:mac_guffins, "MacGuffin", array: true, null: false)
      .authorize { |event|
        return event.authorized! if event.context.current_user

        event.unauthorized!(message: I18n.t("api.authentication.unauthorized"))
      }
      .resolve {
        Demo::MacGuffin.accessible_by(request.context.current_ability).order(:id)
      }
  end
end
