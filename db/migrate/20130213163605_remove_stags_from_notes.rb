class RemoveStagsFromNotes < ActiveRecord::Migration
  def change
    remove_column :notes, :stags
  end
end
