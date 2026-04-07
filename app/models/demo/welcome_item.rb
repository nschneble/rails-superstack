# Immutable value object representing a feature showcase item

Demo::WelcomeItem = Data.define(:avatar, :description, :byline, :hidden) do
  include Draper::Decoratable

  def initialize(byline: nil, hidden: false, **args)
    super(**args, byline:, hidden:)
  end
end
