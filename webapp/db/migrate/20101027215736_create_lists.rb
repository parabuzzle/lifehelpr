class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.column :user_id, :int, :null=>false
      t.column :name, :string
      t.column :position, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :lists
  end
end
