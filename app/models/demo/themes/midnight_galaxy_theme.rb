module Demo::Themes
  MidnightGalaxyTheme = Theme.new(
    key: "midnight_galaxy",
    name: I18n.t("themes.midnight_galaxy.name"),
    price_cents: 1499,
    description: I18n.t("themes.midnight_galaxy.description"),
    palette: Palettes::Palette.new(
      bgr: "bg-indigo-950!",
      txt: "text-slate-100!",
      btn: "bg-violet-600!",
      lbl: "text-violet-50!",
      cta: "text-cyan-300!"
    )
  )
end
