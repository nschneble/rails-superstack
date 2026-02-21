class LikeNotifier < ApplicationNotifier
  required_params :actor

  deliver_by :email do |config|
    config.mailer = "UserMailer"
    config.method = :mac_guffin_liked
  end

  notification_methods do
    def message
      I18n.t(
        "notifiers.like_notifier.notification.message",
        actor_email: params[:actor].email,
        mac_guffin_name: record.name
      )
    end
  end
end
