class Settings::ApiTokensController < AuthenticatedController
  def create
    token = ApiToken.issue!(user: current_user, name: api_token_params[:name])
    session[:api_token_plaintext] = token.plaintext_token

    redirect_to settings_api_path, notice: t("user_profile.api_tokens.notices.created")
  rescue ActiveRecord::RecordInvalid => exception
    redirect_to settings_api_path, alert: exception.record.errors.full_messages.to_sentence
  end

  def destroy
    token = current_user.api_tokens.active.find(params[:id])
    token.revoke!

    redirect_to settings_api_path, notice: t("user_profile.api_tokens.notices.revoked")
  end

  private

  def api_token_params
    params.require(:api_token).permit(:name)
  end
end
