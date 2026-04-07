# Grants signed-in users the ability to manage their own records

module Abilities::Users
  def self.apply(ability, user)
    if user.present?
      ability.can :manage, User, id: user.id
      ability.can :read, User, role: :user

      # define any additional permissions for signed-in users here
      # e.g. ability.can :write, Post, user: user
    end
  end
end

Ability.register(Abilities::Users)
