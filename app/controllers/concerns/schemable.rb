# Provides helpers for GraphQL schemas

module Schemable
  def current_config
    schema = params[:schema].presence || "graphql"
    return schema_configs.fetch(schema) if schema_configs.key?(schema)

    raise ActionController::BadRequest, t("graphql.unknown_schema", schema:)
  end

  def schema_configs
    @configs ||= Rails.application.routes.routes.each_with_object({}) do |route, configs|
      key, config = extract_route_config(route.defaults, route.verb, route.path)
      configs[key] = config if config
    end
  end

  private

  # :reek:TooManyStatements — it's a route-filtering pipeline, get fucked
  def extract_route_config(defaults, verb, path)
    execute_path = path.spec.to_s.sub("(.:format)", "")
    controller = "#{defaults[:controller]&.classify}Controller".safe_constantize

    return unless defaults[:action] == "execute" &&
                  verb.include?("POST") &&
                  execute_path.start_with?("/graphql") &&
                  controller.try(:gql_schema).present?

    key = execute_path.delete_prefix("/graphql").delete_prefix("/")
    [ key.presence || "graphql", { schema: controller.gql_schema.constantize, execute_path: } ]
  end
end
