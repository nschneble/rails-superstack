class CreateDemoThemePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :demo_theme_purchases do |t|
      t.bigint :user_id, null: false
      t.string :theme_key, null: false
      t.string :stripe_checkout_session_id
      t.string :stripe_payment_intent_id
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :demo_theme_purchases, :user_id
    # status = 1 corresponds to the "completed" enum value
    add_index :demo_theme_purchases, [ :user_id, :theme_key ], unique: true,
      where: "status = 1", name: "index_demo_theme_purchases_on_user_id_and_theme_key_completed"
    add_index :demo_theme_purchases, :stripe_checkout_session_id, unique: true,
      where: "stripe_checkout_session_id IS NOT NULL"
    add_index :demo_theme_purchases, :stripe_payment_intent_id, unique: true,
      where: "stripe_payment_intent_id IS NOT NULL"

    add_foreign_key :demo_theme_purchases, :users, validate: false
  end
end
