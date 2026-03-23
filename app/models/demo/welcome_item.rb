Demo::WelcomeItem = Data.define(:avatar, :description, :byline, :hidden) do
  include Draper::Decoratable

  def initialize(avatar:, description:, byline: nil, hidden: false)
    super
  end
end
