module Demo::Themes
  Theme = Data.define(
    :key,
    :name,
    :price_cents,
    :description,
    :image,
    :image_attribution,
    :palette
  ) do
    extend Forwardable
    include Draper::Decoratable

    def_delegators :palette, *Palettes::Palette.members

    def initialize(
      price_cents: 0,
      description: "",
      image: nil,
      image_attribution: nil,
      palette: Palettes::DefaultPalette,
      **args
    )
      super(**args, price_cents:, description:, image:, image_attribution:, palette:)
    end

    def selector
      key.dasherize
    end
  end
end
