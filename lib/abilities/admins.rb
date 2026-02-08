module Abilities
  module Admins
    def self.apply(ability, user)
      if user&.admin?
        # define any additional permissions for administrators here
        # e.g. ability.can :manage, Post
      end
    end
  end
end

Ability.register(Abilities::Admins)
