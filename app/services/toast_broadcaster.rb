class ToastBroadcaster
  class << self
    def for_user(user, message, variant: :notice)
      Turbo::StreamsChannel.broadcast_append_to(
        [ user, :toasts ],
        target: "live-toasts",
        partial: "shared/live_toast",
        locals: { message:, variant: }
      )
    end

    def global(message, variant: :notice)
      Turbo::StreamsChannel.broadcast_append_to(
        "global_toasts",
        target: "live-toasts",
        partial: "shared/live_toast",
        locals: { message:, variant: }
      )
    end
  end
end
