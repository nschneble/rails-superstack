class UserMailer < ApplicationMailer
  default from: "no-reply@rails-superstack.dev"

  def email_change_confirmation
    @request = params[:request]
    mail to: @request.new_email, subject: t("users.mailer.email_change.subject")
  end

  def mac_guffin_liked
    @notification = params[:notification]
    @mac_guffin = params[:record]
    @actor = params[:actor]

    mail(
      to: params[:recipient].email,
      subject: t(
        "users.mailer.mac_guffin_liked.subject",
        actor_email: @actor.email,
        mac_guffin_name: @mac_guffin.name
      )
    )
  end
end
