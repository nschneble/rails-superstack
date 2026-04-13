# Provides helpers for rendering Turbo Stream actions

module Streamable
  def stream_api_form(error_message: nil)
    turbo_stream.replace(
      "api_token_form",
      partial: "settings/api_tokens/form",
      locals: { error_message: }
    )
  end

  def stream_api_token_reveal(plaintext_token = nil)
    turbo_stream.replace(
      "api_token_reveal",
      partial: "settings/api_tokens/reveal",
      locals: { plaintext_token: }
    )
  end

  def stream_api_token_add(api_token)
    turbo_stream.prepend(
      "api_tokens_collection",
      partial: "settings/api_tokens/api_token",
      locals: { api_token: }
    )
  end

  def stream_empty_api_state
    turbo_stream.replace(
      "api_tokens_empty",
      partial: "settings/api_tokens/empty",
      locals: { hidden: false }
    )
  end

  def stream_nonempty_api_state
    turbo_stream.replace(
      "api_tokens_empty",
      partial: "settings/api_tokens/empty",
      locals: { hidden: true }
    )
  end

  def stream_notification(message, variant: "notice")
    turbo_stream.append(
      "notifications",
      partial: "shared/notification",
      locals: { variant:, message: }
    )
  end
end
