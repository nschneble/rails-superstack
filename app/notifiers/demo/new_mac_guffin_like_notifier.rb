# Delivers a like notification via Turbo Stream and emails the user

class Demo::NewMacGuffinLikeNotifier < Noticed::Event
  required_params :actor

  deliver_by :turbo_stream do |config|
    config.class = "DeliveryMethods::TurboStream"
    config.stream = -> { [ recipient, :notifications ] }
  end

  deliver_by :email do |config|
    config.mailer = "Demo::MacGuffinMailer"
    config.method = :mac_guffin_liked
  end

  notification_methods do
    def message
      I18n.t(
        "notifiers.mac_guffin_like.message",
        actor: params[:actor].email,
        mac_guffin: record.name
      )
    end
  end
end
