# Manages API token revocation from the settings API tab

class Settings::RevokeApiTokensController < AuthenticatedController
  include Streamable

  def destroy
    api_token = current_user.api_tokens.active.find(params[:id])
    api_token.revoke

    respond_to do |format|
      format.html do
        redirect_to settings_api_path, notice: t("settings.api_tokens.flash.revoked")
      end

      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(api_token),
          stream_api_token_reveal,
          stream_empty_api_state(visible: current_user.api_tokens.active.exists?),
          stream_notification(t("settings.api_tokens.flash.revoked"))
        ]
      end
    end
  end
end
