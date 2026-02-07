class EmailChangesController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    new_email = EmailRules.parse_email(params[:new_email])
    EmailChangeRequest.where(new_email:).expired.delete_all

    if new_email.nil?
      redirect_to user_profile_path, alert: t("email.validation.invalid")
    elsif User.where(email: new_email).exists? || EmailChangeRequest.where(new_email:).active.exists?
      redirect_to user_profile_path, alert: t("email.validation.unavailable")
    else
      request = current_user.email_change_requests.create!(new_email: new_email)
      UserMailer.with(request: request).email_change_confirmation.deliver_later
      redirect_to user_profile_path, notice: t("email.confirmation.link_sent", new_email:)
    end
  end

  def confirm
    request = EmailChangeRequest.find_by!(token: params[:token])
    if request.expired?
      request.destroy
      redirect_back fallback_location: root_path, alert: t("email.confirmation.link_expired")
    elsif User.where(email: request.new_email).where.not(id: request.user_id).exists?
      request.destroy
      redirect_back fallback_location: root_path, alert: t("email.validation.unavailable")
    else
      request.user.update!(
        email: request.new_email,
        email_confirmed_at: Time.current
      )
      request.user.email_change_requests.delete_all
      redirect_back fallback_location: root_path, notice: t("email.confirmation.updated")
    end
  end
end
