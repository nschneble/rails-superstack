module Demo::Themes
  class ThemePurchase < ApplicationRecord
    self.table_name = "demo_theme_purchases"

    belongs_to :user

    enum :status, {
      pending: 0,
      completed: 1,
      failed: 2,
      refunded: 3
    }

    THEMES = {
      CrimsonTideTheme.key => CrimsonTideTheme.decorate,
      ForestCanopyTheme.key => ForestCanopyTheme.decorate,
      MidnightGalaxyTheme.key => MidnightGalaxyTheme.decorate
    }.freeze

    validates :theme_key, presence: true, inclusion: { in: THEMES.keys }

    delegate :name, :price_cents, :description, to: :theme, prefix: true

    def theme
      THEMES[theme_key]
    end
  end
end
