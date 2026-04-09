# Delivers global notifications to all users via Turbo Stream broadcast

class NewGlobalNotificationNotifier < Noticed::Event
  required_params :message

  bulk_deliver_by :turbo_stream do |config|
    config.class = "BulkDeliveryMethods::TurboStream"
    config.stream = "global_notifications"
    config.message = -> { params[:message] }
  end

  notification_methods do
    def message
      params[:message]
    end
  end
end
