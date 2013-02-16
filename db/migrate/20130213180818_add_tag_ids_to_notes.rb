class AddTagIdsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :tag_ids, :string
  end
end
