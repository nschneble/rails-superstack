class Ability
  include CanCan::Ability

  ABILITIES_RELATIVE_PATH = "lib/abilities/**/*.rb"

  def initialize(user)
    @user = user

    define_base_rules
    load_ability_fragments
  end

  private

  def define_base_rules
    # define any generic permissions here
    # can :read, Post, public: true
  end

  def load_ability_fragments
    Dir[Rails.root.join(ABILITIES_RELATIVE_PATH)].sort.each do |file|
      require_dependency file
    end

    self.class.fragments.each do |fragment|
      fragment.apply(self, @user)
    end
  end

  class << self
    def fragments
      @fragments ||= []
    end

    def register(fragment)
      fragments << fragment
    end
  end
end
