class CreateEmailChangeRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :email_change_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :new_email, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.timestamps
    end

    add_index :email_change_requests, :token, unique: true
    add_index :email_change_requests, [ :user_id, :new_email ]
  end
end
