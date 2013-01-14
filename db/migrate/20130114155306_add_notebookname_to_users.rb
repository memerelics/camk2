class AddNotebooknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notebook_name, :string
  end
end
