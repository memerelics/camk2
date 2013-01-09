class RenameContentHashOfNotes < ActiveRecord::Migration
  def up
      add_column    :notes, :content_hash, :string
      remove_column :notes, :contentHash,  :string
  end

  def down
      add_column    :notes, :contentHash,  :string
      remove_column :notes, :content_hash, :string
  end
end
