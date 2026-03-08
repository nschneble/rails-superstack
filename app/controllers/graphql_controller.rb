class GraphQLController < ApplicationController
  include Rails::GraphQL::Controller

  skip_before_action :verify_authenticity_token

  self.gql_schema = "GraphQL::Schemas::AppSchema"

  def describe
    super(current_config.fetch(:schema))
  end

  protected

  def graphiql_settings(mode = nil)
    return super if mode == :cable

    { mode: :fetch, url: current_config.fetch(:execute_path) }
  end

  def gql_context
    super.merge(current_user:, current_ability:)
  end

  private

  def current_config
    schema = params[:schema].presence || "graphql"
    return schema_configs.fetch(schema) if schema_configs.key?(schema)

    raise ActionController::BadRequest, t("graphql.unknown_schema", schema:)
  end

  def schema_configs
    routes = Rails.application.routes.routes

    @configs ||= routes.each_with_object({}) do |route, configs|
      next unless route.defaults[:action] == "execute"
      next unless route.verb.include?("POST")

      execute_path = route.path.spec.to_s.sub("(.:format)", "")
      next unless execute_path.start_with?("/graphql")

      controller = "#{route.defaults[:controller].classify}Controller".safe_constantize
      next unless controller.try(:gql_schema).present?

      schema = controller.gql_schema.constantize
      key = execute_path.delete_prefix("/graphql").delete_prefix("/")
      key = "graphql" if key.blank?

      configs[key] = { schema:, execute_path: }
    end
  end
end
