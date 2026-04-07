module Demo
  # Destroys a MacGuffin like record, if one exists
  class MacGuffinLikes::DestroyService < BaseService
    def call(user:, mac_guffin:, ability:)
      MacGuffinLike.accessible_by(ability).find_by(user:, mac_guffin:)&.destroy
      ServiceResult.ok
    end
  end
end
