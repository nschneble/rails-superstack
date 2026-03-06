module BulkDeliveryMethods
  class TurboStream < Noticed::BulkDeliveryMethod
    required_options :stream, :message

    def deliver
      Turbo::StreamsChannel.broadcast_append_to(
        evaluate_option(:stream),
        target: "notifications",
        partial: "shared/notification",
        locals: {
          message: evaluate_option(:message),
          variant: evaluate_option(:variant) || :info
        }
      )
    end
  end
end
