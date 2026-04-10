# Manages API token creation from the settings API tab

class Settings::CreateApiTokensController < AuthenticatedController
  include Streamable

  SUCCESS_MESSAGE = I18n.t("settings.api_tokens.flash.created")

  def create
    api_token = ApiToken.issue!(user: current_user, name: api_token_params[:name])

    respond_to do |format|
      format.html { session[:api_token_plaintext] = api_token.plaintext_token; redirect_to settings_api_path, notice: SUCCESS_MESSAGE }
      format.turbo_stream { render turbo_stream: create_stream_actions(api_token) }
    end
  rescue ActiveRecord::RecordInvalid => error
    respond_to_api_token_failure(error.record.errors.full_messages.to_sentence)
  end

  private

  def create_stream_actions(api_token)
    [
      stream_api_form,
      stream_api_token_reveal(api_token.plaintext_token),
      stream_api_token_add(api_token.decorate),
      stream_nonempty_api_state,
      stream_notification(SUCCESS_MESSAGE)
    ]
  end

  def respond_to_api_token_failure(error_message)
    respond_to do |format|
      format.html { redirect_to settings_api_path, alert: error_message }
      format.turbo_stream { render turbo_stream: stream_api_form(error_message:), status: :unprocessable_entity }
    end
  end

  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
