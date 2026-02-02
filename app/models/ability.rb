class Ability
  include CanCan::Ability

  def initialize(user)
    define_demo_abilities(user)

    # define any generic permissions here
    # can :read, Post, public: true

    return unless user.present?
    # define any additional permissions for signed-in users here
    # can :read, Post, user: user

    nil unless user.admin?
    # define any additional permissions for administrators here
    # can :read, Post
  end

  private

  def define_demo_abilities(user)
    can :read, Demo::MacGuffin, visibility: :open

    return unless user.present?
    can :read, Demo::MacGuffin, visibility: :user
    can :manage, Demo::MacGuffin, user: user

    return unless user.admin?
    can :manage, Demo::MacGuffin
  end
end
