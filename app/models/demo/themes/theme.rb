module Demo::Themes
  Theme = Data.define(:key, :name, :price_cents, :description, :palette) do
    include Draper::Decoratable

    def initialize(key:, name:, price_cents: 0, description: "", palette: Palettes::DefaultPalette)
      super
    end

    def free?
      price_cents.zero?
    end
  end
end
