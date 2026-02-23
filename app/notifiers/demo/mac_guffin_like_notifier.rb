class Demo::MacGuffinLikeNotifier < ApplicationNotifier
  required_params :actor

  deliver_by :turbo_stream do |config|
    config.class = "DeliveryMethods::TurboStream"
    config.stream = -> { [ recipient, :toasts ] }
  end

  deliver_by :email do |config|
    config.mailer = "UserMailer"
    config.method = :mac_guffin_liked
  end

  notification_methods do
    def message
      I18n.t(
        "notifiers.demo.mac_guffin_like_notifier.notification.message",
        actor_email: params[:actor].email,
        mac_guffin_name: record.name
      )
    end
  end
end
