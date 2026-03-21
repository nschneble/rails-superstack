class EmailChangesController < AuthenticatedController
  def create
    result = Email::RequestService.call(user: current_user, new_email: params[:new_email])

    if result.success?
      flash.notice = t("email.confirmation.link_sent", new_email: result.payload.new_email)
    else
      flash.alert = t("email.validation.#{result.error}")
    end

    redirect_to settings_profile_path
  end

  def update
    result = Email::ConfirmService.call(token: params[:token])

    if result.success?
      flash.notice = t("email.confirmation.updated")
    else
      flash.alert = t("email.confirmation.#{result.error}")
    end

    redirect_back_or_to root_path
  end
end
