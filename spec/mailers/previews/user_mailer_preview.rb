require "factory_bot_rails"

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  include FactoryBot::Syntax::Methods

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/email_change_confirmation
  def email_change_confirmation
    user = create(:user)
    request = create(:email_change_request)

    UserMailer.with(request: request).email_change_confirmation
  end
end
