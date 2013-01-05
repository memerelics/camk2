class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :contentHash
      t.string :title
      t.text :content_raw
      t.text :content_markdown
      t.text :content_html

      t.timestamps
    end
  end
end
