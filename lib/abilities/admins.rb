# Grants admin users full management over users

module Abilities::Admins
  # :reek:ControlParameter — CanCanCan convention
  def self.apply(ability, user)
    if user&.admin?
      ability.can :manage, User, role: :user
      ability.can :read, User, role: :admin

      # define any additional permissions for administrators here
      # e.g. ability.can :manage, Post
    end
  end
end

Ability.register(Abilities::Admins)
