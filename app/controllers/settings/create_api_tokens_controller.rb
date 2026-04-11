# Manages API token creation from the settings API tab

class Settings::CreateApiTokensController < AuthenticatedController
  include Streamable

  SUCCESS_MESSAGE = I18n.t("settings.api_tokens.flash.created")

  def create
    respond_to_create_api_token_success(
      ApiToken.issue!(
        user: current_user,
        name: api_token_params[:name]
      )
    )
  rescue ActiveRecord::RecordInvalid => error
    respond_to_create_api_token_failure(
      error.record.errors.full_messages.to_sentence
    )
  end

  private

  def respond_to_create_api_token_success(api_token)
    respond_to do |format|
      format.html do
        session[:api_token_plaintext] = api_token.plaintext_token
        redirect_to settings_api_path, notice: SUCCESS_MESSAGE
      end
      format.turbo_stream { render turbo_stream: create_stream_actions(api_token) }
    end
  end

  def respond_to_create_api_token_failure(error_message)
    respond_to do |format|
      format.html { redirect_to settings_api_path, alert: error_message }
      format.turbo_stream { render turbo_stream: stream_api_form(error_message:), status: :unprocessable_entity }
    end
  end

  def create_stream_actions(api_token)
    [
      stream_api_form,
      stream_api_token_reveal(api_token.plaintext_token),
      stream_api_token_add(api_token.decorate),
      stream_nonempty_api_state,
      stream_notification(SUCCESS_MESSAGE)
    ]
  end

  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
