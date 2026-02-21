class SystemNotificationNotifier < ApplicationNotifier
  required_params :message

  notification_methods do
    def message
      params[:message]
    end
  end
end
