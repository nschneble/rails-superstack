class SessionsController < Passwordless::SessionsController
  after_action -> { flash.discard(:alert) }

  def create
    User.find_or_create_by(email: normalized_email_param) do |user|
      puts "Creating new user for email `#{user.email}`"
    end

    super
  end
end
