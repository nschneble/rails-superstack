class SessionsController < Passwordless::SessionsController
  before_action :no_users_allowed!, only: %i[new create show update confirm]
  after_action -> { flash.discard(:alert) }

  def create
    User.find_or_create_by(email: normalized_email_param) do |user|
      Rails.logger.info t("passwordless.sessions.create.logging", email: user.email)
    end

    super
  end

  private

  def no_users_allowed!
    return unless authenticate_by_session(User)

    redirect_to root_path, notice: t("passwordless.sessions.errors.session_exists")
  end
end
