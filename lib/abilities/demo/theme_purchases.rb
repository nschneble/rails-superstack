# Grants users access to their theme purchases

module Abilities::Demo::ThemePurchases
  def self.apply(ability, user)
    ability.can :read, Demo::Themes::ThemePurchase, user: user if user.present?
  end
end

Ability.register(Abilities::Demo::ThemePurchases)
