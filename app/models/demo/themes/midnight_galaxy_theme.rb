module Demo::Themes
  MidnightGalaxyTheme = Theme.new(
    key: "midnight_galaxy",
    name: I18n.t("themes.midnight_galaxy.name"),
    price_cents: 1499,
    description: I18n.t("themes.midnight_galaxy.description"),
    image: "/demo/themes/midnight-galaxy.jpg",
    image_attribution: [
      "Photo by",
      { link: "Jeremy Thomas", to: "https://unsplash.com/@jeremythomasphoto" },
      "on",
      { link: "Unsplash", to: "https://unsplash.com/photos/blue-and-purple-galaxy-digital-wallpaper-E0AHdsENmDg" }
    ],
    palette: Palettes::Palette.new(
      background:  "bg-indigo-950!",
      border:      "ring-cyan-300/50!",
      text:        "text-slate-100!",
      button:      "bg-violet-600!",
      button_text: "text-violet-50!",
      highlight:   "text-cyan-300!"
    )
  )
end
