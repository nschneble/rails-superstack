# Grants users management of their own subscriptions

module Abilities::Billing::Subscriptions
  def self.apply(ability, user)
    if user.present?
      ability.can :manage, Subscription, user: user
      ability.can :read, Subscription if user.admin?
    end
  end
end

Ability.register(Abilities::Billing::Subscriptions)
