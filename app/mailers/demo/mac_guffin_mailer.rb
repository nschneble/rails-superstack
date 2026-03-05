class Demo::MacGuffinMailer < ApplicationMailer
  default from: "no-reply@rails-superstack.dev"

  def mac_guffin_liked
    @mac_guffin = params[:record]
    @actor = params[:actor]

    mail to: params[:recipient].email, subject: t("mac_guffins.mailer.liked.subject")
  end
end
