module Demo
  # Immutable value object representing a feature showcase item
  WelcomeItem = Data.define(:avatar, :description, :byline, :visibility) do
    include Draper::Decoratable
    include Serializable

    json_source "lib/data/demo/welcome_items.json"

    def always_visible?
      visibility == "all"
    end
  end
end
