# Manages API token creation from the settings API tab

class Settings::CreateApiTokensController < AuthenticatedController
  include Streamable

  def create
    api_token = ApiToken.issue!(user: current_user, name: api_token_params[:name])
    respond_to_successful_create(api_token)
  rescue ActiveRecord::RecordInvalid => exception
    respond_to_failed_create(exception.record.errors.full_messages.to_sentence)
  end

  private

  # :reek:TooManyStatements — extract token + notice, respond_to with html+turbo_stream branches; each step is a required response action
  def respond_to_successful_create(api_token)
    plaintext_token = api_token.plaintext_token
    notice = t("settings.api_tokens.flash.created")
    respond_to do |format|
      format.html { session[:api_token_plaintext] = plaintext_token; redirect_to settings_api_path, notice: }
      format.turbo_stream do
        render turbo_stream: [
          stream_api_form,
          stream_api_token_reveal(plaintext_token),
          stream_api_token_add(api_token.decorate),
          stream_empty_api_state,
          stream_notification(notice)
        ]
      end
    end
  end

  def respond_to_failed_create(alert)
    respond_to do |format|
      format.html { redirect_to settings_api_path, alert: }
      format.turbo_stream { render turbo_stream: stream_api_form(error_message: alert), status: :unprocessable_entity }
    end
  end

  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
