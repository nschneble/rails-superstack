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

    def selector
      key.dasherize
    end

    class << self
      def all
        @all ||= load_from_json
      end

      def find(key)
        all.find { |theme| theme.key == key }
      end

      def default
        find("default")
      end

      def purchasable
        all.reject { |theme| theme.key == "default" }
      end

      private

      def load_from_json
        data = JSON.parse(
          File.read(Rails.root.join("lib/data/demo/themes.json")),
          symbolize_names: true
        )
        data.map do |attrs|
          new(
            key: attrs[:key],
            name: attrs[:name],
            price_cents: attrs[:price_cents],
            description: attrs[:description],
            image: attrs[:image],
            image_attribution: attrs[:image_attribution],
            palette: Palettes::Palette.new(**attrs[:palette])
          )
        end
      end
    end
  end
end
