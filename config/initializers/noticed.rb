ActiveSupport.on_load(:noticed_event) do
  Noticed::NotificationMethods::ClassMethods.class_eval do
    def inherited(notifier)
      super
      parent_notification = const_defined?(:Notification, false) ? const_get(:Notification) : ::Noticed::Notification
      notifier.const_set(:Notification, Class.new(parent_notification))
    end
  end
end
