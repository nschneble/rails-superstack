class ValidateForeignKeys < ActiveRecord::Migration[8.1]
  def change
    validate_foreign_key :subscriptions, :users
    validate_foreign_key :demo_theme_purchases, :users
  end
end
