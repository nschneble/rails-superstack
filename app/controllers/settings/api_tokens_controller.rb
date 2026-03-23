class Settings::ApiTokensController < AuthenticatedController
  def create
    api_token = ApiToken.issue!(user: current_user, name: api_token_params[:name])

    respond_to do |format|
      format.html do
        session[:api_token_plaintext] = api_token.plaintext_token
        redirect_to settings_api_path, notice: t("settings.api_tokens.flash.created")
      end

      format.turbo_stream do
        render turbo_stream: [
          render_api_token_form,
          render_api_token_reveal(api_token.plaintext_token),
          turbo_stream.prepend(
            "api_tokens_collection",
            partial: "settings/api_tokens/api_token",
            locals: { api_token: api_token.decorate }
          ),
          render_api_tokens_empty,
          render_notification(t("settings.api_tokens.flash.created"))
        ]
      end
    end
  rescue ActiveRecord::RecordInvalid => exception
    alert = exception.record.errors.full_messages.to_sentence

    respond_to do |format|
      format.html do
        redirect_to settings_api_path, alert:
      end

      format.turbo_stream do
        render turbo_stream: render_api_token_form(alert), status: :unprocessable_entity
      end
    end
  end

  def destroy
    api_token = current_user.api_tokens.active.find(params[:id])
    api_token.revoke!

    respond_to do |format|
      format.html do
        redirect_to settings_api_path, notice: t("settings.api_tokens.flash.revoked")
      end

      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(api_token),
          render_api_token_reveal,
          render_api_tokens_empty(current_user.api_tokens.active.exists?),
          render_notification(t("settings.api_tokens.flash.revoked"))
        ]
      end
    end
  end

  private

  def api_token_params
    params.require(:api_token).permit(:name)
  end

  def render_api_token_form(error_message = nil)
    turbo_stream.replace(
      "api_token_form",
      partial: "settings/api_tokens/form",
      locals: { error_message: }
    )
  end

  def render_api_token_reveal(plaintext_token = nil)
    turbo_stream.replace(
      "api_token_reveal",
      partial: "settings/api_tokens/reveal",
      locals: { plaintext_token: }
    )
  end

  def render_api_tokens_empty(hidden = true)
    turbo_stream.replace(
      "api_tokens_empty",
      partial: "settings/api_tokens/empty",
      locals: { hidden: }
    )
  end

  def render_notification(message)
    turbo_stream.append(
      "notifications",
      partial: "shared/notification",
      locals: { variant: "notice", message: }
    )
  end
end
