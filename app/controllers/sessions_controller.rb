class SessionsController < Passwordless::SessionsController
  before_action :no_users_allowed!, only: %i[new show]
  after_action -> { flash.discard(:alert) }

  def new
    super
  end

  def create
    User.find_or_create_by(email: normalized_email_param) do |user|
      puts t("passwordless.sessions.create.logging", email: user.email)
    end

    super
  end

  def show
    super
  end

  private

  def no_users_allowed!
    return unless current_user
    redirect_to "/", notice: t("passwordless.sessions.errors.session_exists")
  end
end
