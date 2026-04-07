module Demo
  module Themes
    # Represents a purchasable demo theme with pricing and attribution data
    Theme = Data.define(:key, :name, :price_cents, :description, :image, :image_attribution, :palette) do
      extend Forwardable

      include Draper::Decoratable
      include Serializable

      json_source "lib/data/demo/themes.json"

      def_delegators :palette, *Palettes::Palette.members

      def initialize(palette:, **args)
        super(**args, palette: Palettes::Palette.new(**palette))
      end

      def selector
        key.dasherize
      end

      class << self
        def find(key)
          all.find { |theme| theme.key == key }
        end

        def default
          find("default")
        end

        def purchasable
          all.reject { |theme| theme.key == "default" }
        end
      end
    end
  end
end
