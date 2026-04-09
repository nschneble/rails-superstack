module Demo
  # Creates a MacGuffin like record and delivers a user notification
  class MacGuffinLikes::CreateService < BaseService
    def call(user:, mac_guffin:, ability:)
      like = MacGuffinLike.accessible_by(ability).find_or_initialize_by(user:, mac_guffin:)

      if like.save
        NewMacGuffinLikeNotifier.with(record: mac_guffin, actor: user).deliver(mac_guffin.user)
        ServiceResult.ok(like)
      else
        ServiceResult.fail(like.errors.full_messages.to_sentence)
      end
    end
  end
end
