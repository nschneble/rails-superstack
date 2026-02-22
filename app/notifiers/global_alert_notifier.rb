class GlobalAlertNotifier < ApplicationNotifier
  required_params :message

  bulk_deliver_by :turbo_stream do |config|
    config.class = "BulkDeliveryMethods::TurboStream"
    config.stream = "global_toasts"
    config.message = -> { params[:message] }
  end

  notification_methods do
    def message
      params[:message]
    end
  end
end
