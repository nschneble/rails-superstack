module Abilities::Demo::ThemePurchases
  def self.apply(ability, user)
    if user.present?
      ability.can :read, Demo::Themes::ThemePurchase, user: user
    end

    if user&.admin?
      ability.can :manage, Demo::Themes::ThemePurchase
    end
  end
end

Ability.register(Abilities::Demo::ThemePurchases)
