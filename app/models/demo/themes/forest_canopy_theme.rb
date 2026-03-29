module Demo::Themes
  ForestCanopyTheme = Theme.new(
    key: "forest_canopy",
    name: I18n.t("themes.forest_canopy.name"),
    price_cents: 499,
    description: I18n.t("themes.forest_canopy.description"),
    image: "/demo/themes/forest-canopy.jpg",
    image_attribution: [
      "Photo by",
      { link: "rawkkim", to: "https://unsplash.com/@rawkkim" },
      "on",
      { link: "Unsplash", to: "https://unsplash.com/photos/low-angle-photography-of-green-trees-at-daytime-m0kfaAwasEE" }
    ],
    palette: Palettes::Palette.new(
      background:  "bg-green-950!",
      border:      "ring-green-400/80!",
      text:        "text-stone-100!",
      button:      "bg-amber-700!",
      button_text: "text-amber-50!",
      highlight:   "text-green-400!"
    )
  )
end
