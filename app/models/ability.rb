class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :home
    can :read, MacGuffin, visibility: :open

    return unless user.present?
    can :read, MacGuffin, visibility: :user
    can :manage, MacGuffin, user: :user

    return unless user.admin?
    can :read, MacGuffin, visibility: :admin
  end
end
