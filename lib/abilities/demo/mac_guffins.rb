module Abilities
  module Demo
    module MacGuffins
      def self.apply(ability, user)
        ability.can :read, ::Demo::MacGuffin, visibility: :open

        if user.present?
          ability.can :read, ::Demo::MacGuffin, visibility: :user
          ability.can :manage, ::Demo::MacGuffin, user: user
        end

        if user&.admin?
          ability.can :read, ::Demo::MacGuffin, visibility: :admin
          ability.can :manage, ::Demo::MacGuffin
        end
      end
    end
  end
end

Ability.register(Abilities::Demo::MacGuffins)
