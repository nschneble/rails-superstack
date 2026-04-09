# Provides helpers for rendering Turbo Stream actions

module Streamable
  def stream_api_form(error_message: nil)
    turbo_stream_action(:replace, "api_token_form", "settings/api_tokens/form", error_message:)
  end

  def stream_api_token_reveal(plaintext_token = nil)
    turbo_stream_action(:replace, "api_token_reveal", "settings/api_tokens/reveal", plaintext_token:)
  end

  def stream_api_token_add(api_token)
    turbo_stream_action(:prepend, "api_tokens_collection", "settings/api_tokens/api_token", api_token:)
  end

  # :reek:BooleanParameter — visible: drives a CSS hidden/shown toggle; splitting into two methods adds indirection
  def stream_empty_api_state(visible: false)
    turbo_stream_action(:replace, "api_tokens_empty",  "settings/api_tokens/empty", hidden: !visible)
  end

  def stream_notification(message, variant: "notice")
    turbo_stream_action(:append, "notifications", "shared/notification", variant:, message:)
  end

  private

  # :reek:LongParameterList — 4 positional args + locals; this is a low-level helper that maps directly to turbo_stream
  def turbo_stream_action(method, dom_id, partial, **locals)
    turbo_stream.public_send(method, dom_id, partial:, locals:)
  end
end
