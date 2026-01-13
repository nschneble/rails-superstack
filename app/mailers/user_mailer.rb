class UserMailer < ApplicationMailer
  default from: "no-reply@superstack.dev"

  def email_change_confirmation
    @request = params[:request]
    mail to: @request.new_email, subject: t("users.mailer.email_change.subject")
  end
end
