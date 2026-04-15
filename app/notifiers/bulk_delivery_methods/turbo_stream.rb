module BulkDeliveryMethods
  # Noticed bulk delivery broadcast to a Turbo Stream channel
  class TurboStream < Noticed::BulkDeliveryMethod
    required_options :stream, :message

    def deliver
      Turbo::StreamsChannel.broadcast_append_to(
        evaluate_option(:stream),
        target: "notifications",
        partial: "shared/notification",
        locals: {
          message: evaluate_option(:message),
          variant: evaluate_option(:variant) || :info,
          notification_id: event.id
        }
      )
    end
  end
end
