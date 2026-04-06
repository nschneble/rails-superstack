class AddPasswordlessTrackingToUsers < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_column :users, :email_confirmed_at, :datetime
    add_column :users, :last_login_at, :datetime
    add_column :users, :last_login_ip, :inet

    add_column :users, :login_count, :integer, null: false, default: 0

    add_index :users, :email_confirmed_at, algorithm: :concurrently
    add_index :users, :last_login_at, algorithm: :concurrently
  end
end
