class CreateListItems < ActiveRecord::Migration
  def self.up
    create_table :list_items do |t|
      t.column :list_id, :int
      t.column :name, :string, :null => false
      t.column :notes, :string
      t.column :status, :boolean, :null => false, :default => false
      t.column :deleted, :boolean, :null => false, :default => false
      t.column :archived, :boolean, :null => false, :default => false
      t.column :position, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :list_items
  end
end
