class SessionsController < Passwordless::SessionsController
  before_action :no_users_allowed!, only: %i[new show]
  after_action -> { flash.discard(:alert) }

  def new
    super
  end

  def create
    User.find_or_create_by(email: normalized_email_param) do |user|
      puts "Creating new user for email `#{user.email}`"
    end

    super
  end

  def show
    super
  end

  private

  def no_users_allowed!
    return unless current_user
    redirect_to("/", notice: "You're already signed in, sillypants")
  end
end
