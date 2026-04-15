# Grants access to MacGuffin likes

module Abilities::Demo::MacGuffinLikes
  def self.apply(ability, user)
    ability.can :read,   Demo::MacGuffinLike
    ability.can :manage, Demo::MacGuffinLike, user: user if user.present?
  end
end

Ability.register(Abilities::Demo::MacGuffinLikes)
