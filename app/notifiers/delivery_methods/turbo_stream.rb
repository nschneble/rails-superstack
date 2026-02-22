module DeliveryMethods
  class TurboStream < ApplicationDeliveryMethod
    required_options :stream

    def deliver
      Turbo::StreamsChannel.broadcast_append_to(
        evaluate_option(:stream),
        target: "live-toasts",
        partial: "shared/live_toast",
        locals: {
          message: resolve_message,
          variant: evaluate_option(:variant) || :notice
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
