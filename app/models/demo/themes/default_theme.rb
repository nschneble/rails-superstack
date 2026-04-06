module Demo::Themes
  DefaultTheme = Theme.new(
    key: "default",
    name: I18n.t("themes.default.name")
  )
end
