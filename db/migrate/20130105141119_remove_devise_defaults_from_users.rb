class RemoveDeviseDefaultsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :email
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
  end

  def down
    add_column :users, :remember_created_at, :string
    add_column :users, :reset_password_sent_at, :string
    add_column :users, :reset_password_token, :string
    add_column :users, :encrypted_password, :string
    add_column :users, :email, :string
  end
end
