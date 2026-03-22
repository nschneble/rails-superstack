class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.bigint :user_id, null: false
      t.string :stripe_customer_id, null: false
      t.string :stripe_subscription_id
      t.string :plan, null: false, default: "free"
      t.integer :status, null: false, default: 0
      t.datetime :cancel_at
      t.datetime :current_period_end_at
      t.datetime :trial_ends_at

      t.timestamps
    end

    add_index :subscriptions, :user_id, unique: true
    add_index :subscriptions, :stripe_customer_id, unique: true
    add_index :subscriptions, :stripe_subscription_id, unique: true,
      where: "stripe_subscription_id IS NOT NULL"
    add_index :subscriptions, :status

    add_foreign_key :subscriptions, :users, validate: false
  end
end
