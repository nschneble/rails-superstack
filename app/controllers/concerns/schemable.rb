# Provides helpers for GraphQL schemas

module Schemable
  def current_config
    schema = params[:schema].presence || "graphql"
    return schema_configs.fetch(schema) if schema_configs.key?(schema)

    raise ActionController::BadRequest, t("graphql.unknown_schema", schema:)
  end

  def schema_configs
    @configs ||= Rails.application.routes.routes.each_with_object({}) do |route, configs|
      key, config = extract_route_config(route)
      configs[key] = config if config
    end
  end

  private

  # :reek:TooManyStatements — 4 guard clauses + 3 assignments; sequential route-filtering pipeline, not reducible
  def extract_route_config(route)
    defaults = route.defaults
    return unless defaults[:action] == "execute" && route.verb.include?("POST")

    execute_path = route.path.spec.to_s.sub("(.:format)", "")
    return unless execute_path.start_with?("/graphql")

    controller = "#{defaults[:controller].classify}Controller".safe_constantize
    return unless controller.try(:gql_schema).present?

    key = execute_path.delete_prefix("/graphql").delete_prefix("/")
    [ key.presence || "graphql", { schema: controller.gql_schema.constantize, execute_path: } ]
  end
end
