module Demo::Themes
  CrimsonTideTheme = Theme.new(
    key: "crimson_tide",
    name: I18n.t("themes.crimson_tide.name"),
    price_cents: 999,
    description: I18n.t("themes.crimson_tide.description")
  )
end
