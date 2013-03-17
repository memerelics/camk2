class CreateAdapters < ActiveRecord::Migration
  def up
    create_table :adapters do |t|
      t.timestamps
      t.belongs_to :user
      t.string :_type

      t.string :service_id
      t.string :api_key
    end
  end

  def down
    drop_table :adapters
  end
end
