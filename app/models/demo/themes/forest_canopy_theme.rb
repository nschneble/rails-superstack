module Demo::Themes
  ForestCanopyTheme = Theme.new(
    key: "forest_canopy",
    name: I18n.t("themes.forest_canopy.name"),
    price_cents: 499,
    description: I18n.t("themes.forest_canopy.description")
  )
end
