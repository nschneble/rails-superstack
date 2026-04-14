# Grants read access based on MacGuffin visibility

module Abilities::Demo::MacGuffins
  def self.apply(ability, user)
    ability.can :read,   Demo::MacGuffin, visibility: :open

    if user.present?
      ability.can :read, Demo::MacGuffin, visibility: :user
      ability.can :read, Demo::MacGuffin, visibility: :admin if user.admin?

      ability.can :manage, Demo::MacGuffin, user: user
    end
  end
end

Ability.register(Abilities::Demo::MacGuffins)
