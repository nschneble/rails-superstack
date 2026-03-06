module Demo
  class MacGuffinLikesController < AuthenticatedController
    def create
      like = MacGuffinLike.accessible_by(current_ability).find_or_initialize_by(user: current_user, mac_guffin:)

      if like.save
        NewMacGuffinLikeNotifier.with(record: mac_guffin, actor: current_user).deliver(mac_guffin.user)
      else
        flash.alert = like.errors.full_messages.to_sentence
      end

      redirect_to redirect_location
    end

    def destroy
      like = MacGuffinLike.accessible_by(current_ability).find_by(user: current_user, mac_guffin:)
      like&.destroy

      redirect_to redirect_location
    end

    private

    def mac_guffin
      @mac_guffin ||= MacGuffin.accessible_by(current_ability).find(params[:mac_guffin_id])
    end

    def redirect_location
      return demo_mac_guffins_path(page: params[:page], q: params[:q]) if params[:page].present? || params[:q].present?

      request.referer.presence || demo_mac_guffins_path
    end
  end
end
