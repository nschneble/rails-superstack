class GraphQL::Schemas::UserSchema < GraphQL::Schema
  namespace :users

  object "User" do
    field :id, :id, null: false
    field :email, :string, null: false
    field :role, :string, null: false
  end

  query_fields do
    field(:users, "User", array: true, null: false) .resolve {
      ::User.accessible_by(request.controller.current_ability).order(:id)
    }
  end
end
