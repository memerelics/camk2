class AddStagsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :stags, :string
  end
end
