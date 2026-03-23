Demo::Themes::Theme = Data.define(:key, :name, :price_cents, :description) do
  include Draper::Decoratable

  def initialize(key:, name:, price_cents: 0, description: "")
    super
  end

  def free?
    price_cents.zero?
  end
end
