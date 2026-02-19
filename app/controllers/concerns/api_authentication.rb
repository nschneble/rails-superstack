module ApiAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_user!
  end

  private

  def current_user
    @current_user ||= authenticate_by_session(User) || authenticate_by_token
  end

  def authenticate_api_user!
    return if current_user

    render json: {
      errors: [
        { message: t("api.authentication.unauthorized") }
      ]
    }, status: :unauthorized
  end

  def authenticate_by_token
    token = parse_bearer_token
    return if token.blank?

    ApiToken.authenticate(token)&.tap(&:mark_used!)&.user
  end

  def parse_bearer_token
    header = request.authorization.to_s
    scheme, token = header.split(" ", 2)
    return unless scheme&.casecmp("Bearer")&.zero?

    token
  end
end
