class Demo::ThemePurchase < ApplicationRecord
  self.table_name = "demo_theme_purchases"

  belongs_to :user

  enum :status, {
    pending: 0,
    completed: 1,
    failed: 2,
    refunded: 3
  }

  THEMES = {
    "midnight_galaxy" => { name: "Midnight Galaxy", price_cents: 1499, description: "A deep space aesthetic with dark indigo backgrounds and glowing star accents." },
    "crimson_tide" => { name: "Crimson Tide", price_cents: 999, description: "Bold crimson reds with warm amber highlights for a striking, energetic feel." },
    "forest_canopy" => { name: "Forest Canopy", price_cents: 499, description: "Earthy greens and soft browns inspired by the serenity of an old-growth forest." }
  }.freeze

  validates :theme_key, presence: true, inclusion: { in: THEMES.keys }

  def theme_name
    THEMES.dig(theme_key, :name)
  end

  def price_cents
    THEMES.dig(theme_key, :price_cents)
  end

  def price_display
    format("$%.2f", price_cents / 100.0)
  end
end
