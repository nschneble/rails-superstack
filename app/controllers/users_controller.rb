class UsersController < AuthenticatedController
  before_action :check_for_email_change_request

  def me
    if @request.present?
      flash.notice = t("email.confirmation.link_sent", new_email: @request.new_email)
      flash.discard
    end
  end

  private

  def check_for_email_change_request
    @request ||= EmailChangeRequest.latest_active_for(current_user)
  end
end
