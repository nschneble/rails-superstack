module  GraphQL::Schemas
  # Demo GraphQL schema for MacGuffin queries
  class Demo::AppSchema < BaseSchema
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
        .authorize(&require_authentication)
        .resolve {
          Demo::MacGuffin.accessible_by(request.context.current_ability).order(:id)
        }
    end
  end
end
