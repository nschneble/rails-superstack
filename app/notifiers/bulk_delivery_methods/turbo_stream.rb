module BulkDeliveryMethods
  class TurboStream < ApplicationBulkDeliveryMethod
    required_options :stream, :message

    def deliver
      Turbo::StreamsChannel.broadcast_append_to(
        evaluate_option(:stream),
        target: "live-toasts",
        partial: "shared/live_toast",
        locals: {
          message: evaluate_option(:message),
          variant: evaluate_option(:variant) || :notice
        }
      )
    end
  end
end
