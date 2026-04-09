module DeliveryMethods
  # Noticed per-recipient delivery via Turbo Stream
  class TurboStream < Noticed::DeliveryMethod
    required_options :stream

    def deliver
      Turbo::StreamsChannel.broadcast_append_to(
        evaluate_option(:stream),
        target: "notifications",
        partial: "shared/notification",
        locals: {
          message: resolve_message,
          variant: evaluate_option(:variant) || :info
        }
      )
    end

    private

    def resolve_message
      return evaluate_option(:message) if config.key?(:message)

      notification.message
    end
  end
end
