class EmailChangesController < AuthenticatedController
  def create
    new_email = EmailParser.call(params[:new_email])
    EmailChangeRequest.where(new_email:).expired.delete_all

    if new_email.nil?
      flash.alert = t("email.validation.invalid")
    elsif User.where(email: new_email).exists? || EmailChangeRequest.where(new_email:).active.exists?
      flash.alert = t("email.validation.unavailable")
    else
      request = current_user.email_change_requests.create!(new_email: new_email)
      UserMailer.with(request: request).email_change_confirmation.deliver_later

      flash.notice = t("email.confirmation.link_sent", new_email:)
    end

    redirect_to user_profile_path(tab:)
  end

  def update
    request = EmailChangeRequest.find_by!(token: params[:token])

    if request.expired?
      request.destroy
      flash.alert = t("email.confirmation.link_expired")
    elsif User.where(email: request.new_email).where.not(id: request.user_id).exists?
      request.destroy
      flash.alert = t("email.validation.unavailable")
    else
      request.user.update!(email: request.new_email, email_confirmed_at: Time.current)
      request.user.email_change_requests.delete_all

      flash.notice =t("email.confirmation.updated")
    end

    redirect_back fallback_location: root_path
  end

  private

  def tab
    if helpers.valid_tab?(params[:tab])
      params[:tab]
    else
      "email"
    end
  end
end
