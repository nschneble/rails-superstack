class Demo::MacGuffinLikesController < AuthenticatedController
  before_action :set_mac_guffin

  def create
    like = current_user.mac_guffin_likes.find_or_initialize_by(mac_guffin: @mac_guffin)

    if like.save
      LikeNotifier.with(record: @mac_guffin, actor: current_user).deliver(@mac_guffin.user)
      ToastBroadcaster.for_user(
        @mac_guffin.user,
        I18n.t(
          "notifiers.like_notifier.notification.message",
          actor_email: current_user.email,
          mac_guffin_name: @mac_guffin.name
        )
      )
      redirect_back fallback_location: demo_mac_guffins_path, notice: "MacGuffin liked"
    else
      redirect_back fallback_location: demo_mac_guffins_path, alert: like.errors.full_messages.to_sentence
    end
  end

  def destroy
    like = current_user.mac_guffin_likes.find_by(mac_guffin: @mac_guffin)
    like&.destroy

    redirect_back fallback_location: demo_mac_guffins_path, notice: "Like removed"
  end

  private

  def set_mac_guffin
    @mac_guffin = Demo::MacGuffin.accessible_by(current_ability).find(params[:mac_guffin_id])
  end
end
