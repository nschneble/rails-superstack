module Demo::Themes
  CrimsonTideTheme = Theme.new(
    key: "crimson_tide",
    name: I18n.t("themes.crimson_tide.name"),
    price_cents: 999,
    description: I18n.t("themes.crimson_tide.description"),
    image: "/demo/themes/crimson-tide.jpg",
    image_attribution: [
      "Photo by",
      { link: "Marc Szeglat", to: "https://unsplash.com/@marcszeglat" },
      "on",
      { link: "Unsplash", to: "https://unsplash.com/photos/eruption-of-volcano-VbP9v1rh-sc" }
    ],
    palette: Palettes::Palette.new(
      bgr: "bg-red-950!",
      bdr: "ring-amber-400/80!",
      txt: "text-red-50!",
      btn: "bg-amber-500!",
      lbl: "text-red-950!",
      cta: "text-amber-400!"
    )
  )
end
