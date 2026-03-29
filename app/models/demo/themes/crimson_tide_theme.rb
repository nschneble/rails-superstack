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
      background:  "bg-red-950!",
      border:      "ring-amber-400/80!",
      text:        "text-red-50!",
      button:      "bg-amber-500!",
      button_text: "text-red-950!",
      highlight:   "text-amber-400!"
    )
  )
end
