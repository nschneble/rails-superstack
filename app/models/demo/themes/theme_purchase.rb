module Demo::Themes
  # Records a user's demo theme purchase with Stripe checkout session tracking
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

    delegate :name, :price_cents, :description, to: :theme, prefix: true, allow_nil: true

    def theme
      Theme.find(theme_key)
    end
  end
end
