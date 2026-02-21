class GraphQL::Schemas::Demo::MacGuffinSchema < GraphQL::Schema
  namespace :demo_mac_guffins

  object "MacGuffin" do
    field :id, :id, null: false
    field :name, :string
    field :description, :string
    field :visibility, :string
    field :user_id, :id, null: false
  end

  query_fields do
    field(:mac_guffins, "MacGuffin", array: true, null: false).resolve {
      ::Demo::MacGuffin.accessible_by(request.controller.current_ability).order(:id)
    }
  end
end
