module Demo::Themes
  MidnightGalaxyTheme = Theme.new(
    key: "midnight_galaxy",
    name: I18n.t("themes.midnight_galaxy.name"),
    price_cents: 1499,
    description: I18n.t("themes.midnight_galaxy.description")
  )
end
