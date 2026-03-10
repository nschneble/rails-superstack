class UsersController < AuthenticatedController
  before_action :check_for_email_change_request
  before_action :check_for_api_tokens
  before_action :set_profile_tab

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

  def check_for_api_tokens
    @api_tokens ||= current_user.api_tokens.active.order(created_at: :desc)
    @new_api_token_plaintext ||= session.delete(:api_token_plaintext)
  end

  def set_profile_tab
    @profile_tab = helpers.valid_tab?(params[:tab]) ? params[:tab] : "email"
  end
end
