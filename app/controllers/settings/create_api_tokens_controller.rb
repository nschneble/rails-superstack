# Manages API token creation from the settings API tab

class Settings::CreateApiTokensController < AuthenticatedController
  include Streamable

  def create
    api_token = ApiToken.issue!(user: current_user, name: api_token_params[:name])
    plaintext_token = api_token.plaintext_token

    respond_to do |format|
      format.html do
        session[:api_token_plaintext] = plaintext_token
        redirect_to settings_api_path, notice: t("settings.api_tokens.flash.created")
      end

      format.turbo_stream do
        render turbo_stream: [
          stream_api_form,
          stream_api_token_reveal(plaintext_token),
          stream_api_token_add(api_token.decorate),
          stream_empty_api_state,
          stream_notification(t("settings.api_tokens.flash.created"))
        ]
      end
    end
  rescue ActiveRecord::RecordInvalid => exception
    alert = exception.record.errors.full_messages.to_sentence

    respond_to do |format|
      format.html { redirect_to settings_api_path, alert: }
      format.turbo_stream { render turbo_stream: stream_api_form(error_message: alert), status: :unprocessable_entity }
    end
  end

  private

  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
