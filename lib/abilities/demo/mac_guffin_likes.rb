module Abilities::Demo::MacGuffinLikes
  def self.apply(ability, user)
    ability.can :read, Demo::MacGuffinLike

    if user.present?
      ability.can :manage, Demo::MacGuffinLike, user: user
    end

    if user&.admin?
      ability.can :manage, Demo::MacGuffinLike
    end
  end
end

Ability.register(Abilities::Demo::MacGuffinLikes)
