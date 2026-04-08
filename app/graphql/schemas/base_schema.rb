# Base GraphQL schema

class GraphQL::Schemas::BaseSchema < GraphQL::Schema
  protected

  def self.require_authentication
    proc { |event|
      return event.authorized! if event.context.current_user

      event.unauthorized!(message: I18n.t("api.authentication.unauthorized"))
    }
  end
end
