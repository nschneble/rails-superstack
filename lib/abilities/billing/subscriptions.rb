# Grants users management of their own subscriptions

module Abilities::Billing::Subscriptions
  def self.apply(ability, user)
    if user.present?
      ability.can :manage, Subscription, user: user
    end

    if user&.admin?
      ability.can :manage, Subscription
    end
  end
end

Ability.register(Abilities::Billing::Subscriptions)
