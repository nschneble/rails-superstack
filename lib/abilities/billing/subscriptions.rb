module Abilities::Billing::Subscriptions
  def self.apply(ability, user)
    if user.present?
      ability.can :manage, Subscription, user: user
      ability.can :access, :pro_features if user.subscription&.active? && user.subscription&.pro?
    end

    ability.can :manage, Subscription if user&.admin?
  end
end

Ability.register(Abilities::Billing::Subscriptions)
