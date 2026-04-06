class DropDemoTables < ActiveRecord::Migration[8.1]
  def change
    drop_table :mac_guffin_likes
    drop_table :mac_guffins
    drop_table :demo_theme_purchases
  end
end
