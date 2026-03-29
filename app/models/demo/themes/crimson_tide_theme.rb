module Demo::Themes
  CrimsonTideTheme = Theme.new(
    key: "crimson_tide",
    name: I18n.t("themes.crimson_tide.name"),
    price_cents: 999,
    description: I18n.t("themes.crimson_tide.description"),
    palette: Palettes::Palette.new(
      bgr: "bg-red-950!",
      txt: "text-red-50!",
      btn: "bg-amber-500!",
      lbl: "text-red-950!",
      cta: "text-amber-400!"
    )
  )
end
