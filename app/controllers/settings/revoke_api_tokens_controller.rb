# Manages API token revocation from the settings API tab

class Settings::RevokeApiTokensController < AuthenticatedController
  include Streamable

  # :reek:TooManyStatements — load tokens, find token, revoke, build message, respond with html+turbo_stream
  def destroy
    active_tokens = current_user.api_tokens.active
    api_token = active_tokens.find(params[:id])
    api_token.revoke
    revoked_msg = t("settings.api_tokens.flash.revoked")

    respond_to do |format|
      format.html { redirect_to settings_api_path, notice: revoked_msg }
      format.turbo_stream { render turbo_stream: revoke_stream_actions(api_token, active_tokens, revoked_msg) }
    end
  end

  private

  def revoke_stream_actions(api_token, active_tokens, message)
    [
      turbo_stream.remove(api_token),
      stream_api_token_reveal,
      stream_empty_api_state(visible: active_tokens.exists?),
      stream_notification(message)
    ]
  end
end
