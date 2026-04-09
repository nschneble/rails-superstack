# Provides helpers for GraphQL schemas

module Schemable
  def current_config
    schema = params[:schema].presence || "graphql"
    return schema_configs.fetch(schema) if schema_configs.key?(schema)

    raise ActionController::BadRequest, t("graphql.unknown_schema", schema:)
  end

  def schema_configs
    @configs ||= Rails.application.routes.routes.each_with_object({}) do |route, configs|
      next unless route.defaults[:action] == "execute" && route.verb.include?("POST")

      execute_path = route.path.spec.to_s.sub("(.:format)", "")
      next unless execute_path.start_with?("/graphql")

      controller = "#{route.defaults[:controller].classify}Controller".safe_constantize
      next unless controller.try(:gql_schema).present?

      key = execute_path.delete_prefix("/graphql").delete_prefix("/")

      configs[key.presence || "graphql"] = {
        schema: controller.gql_schema.constantize,
        execute_path:
      }
    end
  end
end
