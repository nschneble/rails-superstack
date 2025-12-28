class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :home

    return unless user.present?
    # add user abilities

    return unless user.admin?
    # add admin abilities
  end
end
