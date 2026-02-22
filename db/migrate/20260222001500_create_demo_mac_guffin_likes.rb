class CreateDemoMacGuffinLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :demo_mac_guffin_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mac_guffin, null: false, foreign_key: { to_table: :mac_guffins }

      t.timestamps
    end

    add_index :demo_mac_guffin_likes, [ :user_id, :mac_guffin_id ], unique: true
  end
end
