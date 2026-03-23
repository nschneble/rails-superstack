class CreateWebhookEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_events do |t|
      t.string :stripe_event_id, null: false
      t.string :event_type, null: false
      t.integer :status, null: false, default: 0
      t.jsonb :payload, null: false, default: {}
      t.text :error_message

      t.timestamps
    end

    add_index :webhook_events, :stripe_event_id, unique: true
    add_index :webhook_events, :status
    add_index :webhook_events, :event_type
    add_index :webhook_events, :created_at
  end
end
