# Manages API token revocation from the settings API tab

class Settings::RevokeApiTokensController < AuthenticatedController
  include Streamable

  SUCCESS_MESSAGE = I18n.t("settings.api_tokens.flash.revoked")

  def destroy
    api_token = active_tokens.find(params[:id])
    api_token.revoke

    respond_to do |format|
      format.html { redirect_to settings_api_path, notice: SUCCESS_MESSAGE }
      format.turbo_stream { render turbo_stream: revoke_stream_actions(api_token) }
    end
  end

  private

  def active_tokens
    @active_tokens ||= current_user.api_tokens.active
  end

  def revoke_stream_actions(api_token)
    [
      turbo_stream.remove(api_token),
      stream_api_token_reveal,
      active_tokens.exists? ? stream_nonempty_api_state : stream_empty_api_state,
      stream_notification(SUCCESS_MESSAGE)
    ]
  end
end
