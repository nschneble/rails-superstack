class Settings::SettingsController < AuthenticatedController
  before_action :load_email_change_request, only: :profile
  before_action :load_api_tokens, only: :api

  def profile
    @current_settings_tab = :profile
    render :show
  end

  def api
    @current_settings_tab = :api
    render :show
  end

  private

  def load_email_change_request
    @email_change_request = EmailChangeRequest.latest_active_for(current_user)

    if @email_change_request.present?
      flash.notice = t("email.confirmation.link_sent", new_email: @email_change_request.new_email)
      flash.discard
    end
  end

  def load_api_tokens
    @api_tokens ||= current_user.api_tokens.active.order(created_at: :desc)
    @new_api_token_plaintext ||= session.delete(:api_token_plaintext)
  end
end
