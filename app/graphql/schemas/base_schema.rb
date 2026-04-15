# Base GraphQL schema

class GraphQL::Schemas::BaseSchema < GraphQL::Schema
  self.abstract = true

  # Prevents the registration machinery from treating this abstract base class
  # as a real schema. Without this, the gem's Introspection module enables
  # introspection on BaseSchema and the `introspection?` singleton method
  # propagates to subclasses via singleton class inheritance, preventing
  # introspection from being properly enabled on concrete subclasses.

  def self.register!
    return if abstract?

    super
  end

  protected

  def self.require_authentication
    proc { |event|
      return event.authorized! if event.context.current_user

      event.unauthorized!(message: I18n.t("api.authentication.unauthorized"))
    }
  end
end
