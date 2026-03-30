class CreateMacGuffins < ActiveRecord::Migration[8.1]
  def change
    create_table :mac_guffins do |t|
      t.string :name
      t.text :description
      t.integer :visibility
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
