module Demo
  class MacGuffinLikesController < AuthenticatedController
    before_action :set_mac_guffin
    before_action :set_like

    def create
      if @like.save
        Demo::MacGuffinLikeNotifier.with(record: @mac_guffin, actor: current_user).deliver(@mac_guffin.user)

        redirect_back fallback_location: demo_mac_guffins_path
      else
        redirect_back fallback_location: demo_mac_guffins_path, alert: @like.errors.full_messages.to_sentence
      end
    end

    def destroy
      @like.destroy

      redirect_back fallback_location: demo_mac_guffins_path
    end

    private

    def set_mac_guffin
      @mac_guffin ||= Demo::MacGuffin.accessible_by(current_ability).find(params[:mac_guffin_id])
    end

    def set_like
      @like ||= current_user.mac_guffin_likes.find_or_initialize_by(mac_guffin: @mac_guffin)
    end
  end
end
