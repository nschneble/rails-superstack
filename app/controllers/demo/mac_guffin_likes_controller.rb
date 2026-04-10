module Demo
  # Handles creating and destroying MacGuffin likes for authenticated users
  class MacGuffinLikesController < DemoAuthenticatedController
    def create
      result = MacGuffinLikes::CreateService.call(user: current_user, mac_guffin:, ability: current_ability)
      flash.alert = result.error unless result.success?
      redirect_to redirect_location
    end

    def destroy
      MacGuffinLikes::DestroyService.call(user: current_user, mac_guffin:, ability: current_ability)
      redirect_to redirect_location
    end

    private

    def mac_guffin
      @mac_guffin ||= MacGuffin.accessible_by(current_ability).find(params[:mac_guffin_id])
    end

    # :reek:UncommunicativeVariableName — using `q` is the right convention
    def redirect_location
      page = params[:page]
      q = params[:q]

      return demo_mac_guffins_path(page:, q:) if page.present? || q.present?

      request.referer.presence || demo_mac_guffins_path
    end
  end
end
