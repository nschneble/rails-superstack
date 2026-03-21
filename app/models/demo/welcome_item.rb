Demo::WelcomeItem = Data.define(:avatar, :description, :byline, :hidden) do
  def initialize(avatar:, description:, byline: nil, hidden: false)
    super
  end
end
