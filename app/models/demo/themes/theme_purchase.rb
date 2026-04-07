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

    validates :theme_key, presence: true, inclusion: { in: -> { Theme.purchasable.map(&:key) } }

    delegate :name, :price_cents, :description, to: :theme, prefix: true

    def theme
      Theme.find(theme_key)&.decorate
    end
  end
end
